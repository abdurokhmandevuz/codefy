from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from django.contrib.auth.models import User
from django.db.models import F
from .models import UserProfile, Course, Lesson, LessonProgress, PracticeCard, PracticeTask, PracticeTaskProgress
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
    except Exception:
        from .models import UserProfile
        profile = UserProfile.objects.create(user=user)
    if profile.hearts > 0:
        profile.hearts = F('hearts') - 1
        profile.save()
        profile.refresh_from_db()
    
    return Response({
        'status': 'success',
        'hearts': profile.hearts
    })

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_courses(request):
    courses = Course.objects.all()
    serializer = CourseSerializer(courses, many=True, context={'request': request})
    return Response(serializer.data)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_lesson_detail(request, lesson_id):
    try:
        lesson = Lesson.objects.get(id=lesson_id)
        return Response({
            'id': lesson.id,
            'title': lesson.title,
            'content': lesson.content,
            'initial_code': lesson.initial_code,
            'expected_output': lesson.expected_output,
            'is_premium': lesson.is_premium
        })
    except Lesson.DoesNotExist:
        return Response({'error': 'Lesson not found'}, status=status.HTTP_404_NOT_FOUND)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def complete_lesson(request, lesson_id):
    try:
        lesson = Lesson.objects.get(id=lesson_id)
        progress, created = LessonProgress.objects.get_or_create(
            user=request.user,
            lesson=lesson
        )
        
        if progress.status != 'completed':
            progress.status = 'completed'
            progress.progress_percent = 100
            progress.save()
            
            # Add XP
            try:
                profile = request.user.userprofile
            except Exception:
                from .models import UserProfile
                profile = UserProfile.objects.create(user=request.user)
            profile.total_xp += 10
            profile.coins += 5
            profile.save()
            
        return Response({'status': 'success', 'xp_earned': 10})
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

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
            except Exception:
                from .models import UserProfile
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
