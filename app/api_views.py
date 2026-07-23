from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from django.contrib.auth.models import User
from .models import UserProfile, Course, Lesson, LessonProgress, PracticeCard
from .api_serializers import UserSerializer, CourseSerializer, LessonSerializer, PracticeCardSerializer
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth.hashers import make_password

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
            profile = request.user.userprofile
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
    serializer = PracticeCardSerializer(cards, many=True)
    return Response(serializer.data)
