from rest_framework import serializers
from django.contrib.auth.models import User
from .models import UserProfile, Course, Module, Lesson, LessonProgress, PracticeCard, PracticeTask, PracticeTaskProgress

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

class PracticeTaskSerializer(serializers.ModelSerializer):
    is_completed = serializers.SerializerMethodField()

    class Meta:
        model = PracticeTask
        fields = ['id', 'title', 'description', 'initial_code', 'expected_output', 'difficulty', 'xp_reward', 'order', 'is_completed']

    def get_is_completed(self, obj):
        user = self.context['request'].user
        if user.is_authenticated:
            progress = PracticeTaskProgress.objects.filter(user=user, task=obj).first()
            return progress.is_completed if progress else False
        return False

class PracticeCardSerializer(serializers.ModelSerializer):
    tasks = PracticeTaskSerializer(many=True, read_only=True)

    class Meta:
        model = PracticeCard
        fields = ['id', 'title', 'description', 'icon_emoji', 'order', 'tasks']
