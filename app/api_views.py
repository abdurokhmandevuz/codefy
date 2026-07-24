from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from django.contrib.auth.models import User
from django.db import transaction
from django.db.models import F
from .models import UserProfile, Course, Module, Lesson, LessonProgress, PracticeCard, PracticeTask, PracticeTaskProgress
from .api_serializers import UserSerializer, CourseSerializer, LessonSerializer, PracticeCardSerializer, UserProfileSerializer
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth.hashers import make_password
from drf_spectacular.utils import extend_schema

@api_view(['POST'])
@permission_classes([AllowAny])
def register_user(request):
    data = request.data
    try:
        if User.objects.filter(username=data['username']).exists():
            return Response({'error': 'Username already exists'}, status=status.HTTP_400_BAD_REQUEST)
            
        user = User.objects.create(
            username=data['username'],
            email=data.get('email', ''),
            password=make_password(data['password'])
        )
        UserProfile.objects.create(user=user)
        
        refresh = RefreshToken.for_user(user)
        return Response({
            'refresh': str(refresh),
            'access': str(refresh.access_token),
            'user': UserSerializer(user).data
        })
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_user_profile(request):
    user = request.user
    serializer = UserSerializer(user)
    return Response(serializer.data)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
@extend_schema(exclude=True)
def update_user_profile(request):
    user = request.user
    data = request.data
    
    if 'first_name' in data:
        user.first_name = data['first_name']
    if 'last_name' in data:
        user.last_name = data['last_name']
    user.save()
    
    return Response({'status': 'success'})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
@extend_schema(exclude=True)
def decrease_heart(request):
    user = request.user
    try:
        profile = user.userprofile
    except UserProfile.DoesNotExist:
        profile = UserProfile.objects.create(user=user)
    if profile.hearts > 0:
        profile.hearts = F('hearts') - 1
        profile.save()
        profile.refresh_from_db()
    
    return Response({
        'status': 'success',
        'hearts': profile.hearts
    })

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def refill_hearts(request):
    user = request.user
    try:
        profile = user.userprofile
    except UserProfile.DoesNotExist:
        profile = UserProfile.objects.create(user=user)
        
    COST = 20
    if profile.coins >= COST and profile.hearts < 5:
        profile.coins = F('coins') - COST
        profile.hearts = 5
        profile.save()
        profile.refresh_from_db()
        return Response({
            'status': 'success',
            'hearts': profile.hearts,
            'coins': profile.coins
        })
    else:
        return Response({
            'status': 'error',
            'message': 'Not enough coins or hearts already full.'
        }, status=400)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_courses(request):
    courses = Course.objects.all()
    user = request.user if (hasattr(request, 'user') and request.user.is_authenticated) else None
    progress_map = {}
    if user:
        progresses = LessonProgress.objects.filter(user=user)
        progress_map = {p.lesson_id: p for p in progresses}
    serializer = CourseSerializer(courses, many=True, context={'request': request, 'user': user, 'progress_map': progress_map})
    return Response(serializer.data)

@api_view(['GET'])
@permission_classes([AllowAny])
def get_lesson_detail(request, lesson_id):
    try:
        lesson = Lesson.objects.get(id=lesson_id)
        user = request.user if (hasattr(request, 'user') and request.user.is_authenticated) else None
        progress = None
        progress_map = {}
        if user:
            progress = LessonProgress.objects.filter(user=user, lesson=lesson).first()
            if progress:
                progress_map[lesson.id] = progress
        serializer = LessonSerializer(lesson, context={
            'request': request,
            'user': user,
            'progress': progress,
            'progress_map': progress_map
        })
        return Response(serializer.data)
    except Lesson.DoesNotExist:
        return Response({'error': 'Lesson not found'}, status=status.HTTP_404_NOT_FOUND)

@api_view(['POST'])
@permission_classes([AllowAny])
def complete_lesson(request, lesson_id):
    try:
        lesson = Lesson.objects.get(id=lesson_id)
    except Lesson.DoesNotExist:
        return Response({'success': False, 'message': 'Lesson not found'}, status=status.HTTP_404_NOT_FOUND)
        
    user = request.user
    if not user or user.is_anonymous:
        user = User.objects.first()

    if not user:
        return Response({'success': False, 'message': 'User not found'}, status=status.HTTP_400_BAD_REQUEST)

    data = request.data or {}
    answer = data.get('answer')

    # Validate answer based on lesson type
    if lesson.type == 'test':
        is_correct = False
        if answer is not None:
            user_str = str(answer).strip()
            correct_str = str(lesson.correct_option).strip()
            if user_str == correct_str:
                is_correct = True
            elif user_str.isdigit() and isinstance(lesson.options, list):
                idx = int(user_str)
                if 0 <= idx < len(lesson.options) and str(lesson.options[idx]).strip() == correct_str:
                    is_correct = True
            elif correct_str.isdigit() and isinstance(lesson.options, list):
                idx = int(correct_str)
                if 0 <= idx < len(lesson.options) and str(lesson.options[idx]).strip() == user_str:
                    is_correct = True
        if not is_correct:
            return Response({'success': False, 'message': 'Incorrect answer'}, status=status.HTTP_400_BAD_REQUEST)

    elif lesson.type == 'code':
        if lesson.expected_output:
            if answer is None or str(answer).strip() != str(lesson.expected_output).strip():
                return Response({'success': False, 'message': 'Incorrect answer'}, status=status.HTTP_400_BAD_REQUEST)

    with transaction.atomic():
        # Update LessonProgress for current lesson
        progress, _ = LessonProgress.objects.get_or_create(user=user, lesson=lesson)
        progress.status = 'completed'
        progress.progress_percent = 100
        progress.save()

        # Update UserProfile stats
        try:
            profile = user.userprofile
        except UserProfile.DoesNotExist:
            profile = UserProfile.objects.create(user=user)

        profile.total_xp += lesson.xp_reward
        profile.coins += lesson.coins_reward
        profile.save()
        profile.refresh_from_db()

        # Find next lesson in order
        next_lesson = Lesson.objects.filter(module=lesson.module, order__gt=lesson.order).order_by('order').first()
        if not next_lesson and lesson.module:
            next_module = Module.objects.filter(course=lesson.module.course, order__gt=lesson.module.order).order_by('order').first()
            if next_module:
                next_lesson = Lesson.objects.filter(module=next_module).order_by('order').first()

        if next_lesson:
            next_progress, _ = LessonProgress.objects.get_or_create(user=user, lesson=next_lesson)
            if next_progress.status != 'completed':
                next_progress.status = 'in_progress'
                next_progress.save()

    return Response({
        'success': True,
        'message': 'Lesson completed successfully',
        'gained_xp': lesson.xp_reward,
        'gained_coins': lesson.coins_reward,
        'user_stats': {
            'coins': profile.coins,
            'xp': profile.total_xp,
            'streak': profile.streak_days
        },
        'next_lesson_id': next_lesson.id if next_lesson else None
    })

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_practice_cards(request):
    cards = PracticeCard.objects.all().order_by('order')
    # Pass request context so PracticeTaskSerializer can access request.user
    serializer = PracticeCardSerializer(cards, many=True, context={'request': request})
    return Response(serializer.data)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def complete_practice_task(request, task_id):
    try:
        task = PracticeTask.objects.get(id=task_id)
        progress, created = PracticeTaskProgress.objects.get_or_create(
            user=request.user,
            task=task
        )
        
        if not progress.is_completed:
            progress.is_completed = True
            progress.save()
            
            # Add XP
            try:
                profile = request.user.userprofile
            except UserProfile.DoesNotExist:
                profile = UserProfile.objects.create(user=request.user)
            profile.total_xp += task.xp_reward
            profile.coins += task.xp_reward // 2
            profile.save()
            
        return Response({'status': 'success', 'xp_earned': task.xp_reward})
    except PracticeTask.DoesNotExist:
        return Response({'error': 'Task not found'}, status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_leaderboard(request):
    # Fetch top 100 users ordered by total_xp descending
    profiles = UserProfile.objects.filter(total_xp__gt=0).order_by('-total_xp')[:100]
    leaderboard_data = []
    
    for idx, profile in enumerate(profiles):
        leaderboard_data.append({
            'rank': idx + 1,
            'id': profile.user.id,
            'username': profile.user.first_name or profile.user.username,
            'total_xp': profile.total_xp,
            'avatar': profile.avatar.url if profile.avatar else None,
            'league': profile.league,
            'is_current_user': profile.user == request.user
        })
        
    return Response(leaderboard_data)
