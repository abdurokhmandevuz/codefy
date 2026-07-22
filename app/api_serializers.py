from rest_framework import serializers
from django.contrib.auth.models import User
from .models import UserProfile, Course, Module, Lesson, LessonProgress

class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserProfile
        fields = ['experience_level', 'total_xp', 'streak_days', 'coins', 'hearts', 'league', 'is_pro']

class UserSerializer(serializers.ModelSerializer):
    profile = UserProfileSerializer(source='userprofile', read_only=True)
    
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name', 'profile']

class LessonSerializer(serializers.ModelSerializer):
    is_completed = serializers.SerializerMethodField()
    
    class Meta:
        model = Lesson
        fields = ['id', 'title', 'description', 'order', 'is_premium', 'is_practice', 'is_completed']
        
    def get_is_completed(self, obj):
        user = self.context['request'].user
        if user.is_authenticated:
            progress = LessonProgress.objects.filter(user=user, lesson=obj).first()
            return progress.status == 'completed' if progress else False
        return False

class ModuleSerializer(serializers.ModelSerializer):
    lessons = LessonSerializer(many=True, read_only=True)
    
    class Meta:
        model = Module
        fields = ['id', 'title', 'description', 'order', 'lessons']

class CourseSerializer(serializers.ModelSerializer):
    modules = ModuleSerializer(many=True, read_only=True)
    
    class Meta:
        model = Course
        fields = ['id', 'title', 'description', 'track_type', 'modules']
