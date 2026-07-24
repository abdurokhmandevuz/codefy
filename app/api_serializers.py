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
    is_unlocked = serializers.SerializerMethodField()
    
    class Meta:
        model = Lesson
        fields = [
            'id', 'title', 'description', 'type', 'content', 'options',
            'correct_option', 'initial_code', 'expected_output',
            'xp_reward', 'coins_reward', 'order', 'is_premium',
            'is_practice', 'is_unlocked', 'is_completed'
        ]
        
    def _get_user(self):
        if not self.context:
            return None
        user = self.context.get('user')
        if not user:
            request = self.context.get('request')
            if request and hasattr(request, 'user') and request.user.is_authenticated:
                user = request.user
        return user if (user and user.is_authenticated) else None

    def _get_progress_status(self, progress_item):
        if progress_item is None:
            return None
        if hasattr(progress_item, 'status'):
            return progress_item.status
        if isinstance(progress_item, str):
            return progress_item
        if isinstance(progress_item, dict):
            return progress_item.get('status')
        return None

    def _get_from_progress_map(self, progress_map, lesson_id):
        if not isinstance(progress_map, dict):
            return None, False
        if lesson_id in progress_map:
            return progress_map[lesson_id], True
        str_id = str(lesson_id)
        if str_id in progress_map:
            return progress_map[str_id], True
        return None, False

    def get_is_completed(self, obj):
        if self.context and 'progress_map' in self.context:
            progress_map = self.context.get('progress_map')
            item, found = self._get_from_progress_map(progress_map, obj.id)
            if found and item:
                return self._get_progress_status(item) == 'completed'
            return False

        if self.context and 'progress' in self.context:
            progress = self.context.get('progress')
            if progress:
                return self._get_progress_status(progress) == 'completed'
            return False

        user = self._get_user()
        if not user:
            return False

        progress = LessonProgress.objects.filter(user=user, lesson=obj).first()
        return progress.status == 'completed' if progress else False

    def get_is_unlocked(self, obj):
        if self.context and 'progress_map' in self.context:
            progress_map = self.context.get('progress_map')
            item, found = self._get_from_progress_map(progress_map, obj.id)
            if found and item:
                if self._get_progress_status(item) in ['in_progress', 'completed']:
                    return True

            if obj.order == 1:
                return True

            prev_lesson = Lesson.objects.filter(module=obj.module, order__lt=obj.order).order_by('-order').first()
            if not prev_lesson:
                return True

            prev_item, prev_found = self._get_from_progress_map(progress_map, prev_lesson.id)
            if prev_found and prev_item:
                return self._get_progress_status(prev_item) == 'completed'

            return False

        if self.context and 'progress' in self.context:
            progress = self.context.get('progress')
            if progress:
                if self._get_progress_status(progress) in ['in_progress', 'completed']:
                    return True
            if obj.order == 1:
                return True
            user = self._get_user()
            if not user:
                return False
            prev_lesson = Lesson.objects.filter(module=obj.module, order__lt=obj.order).order_by('-order').first()
            if not prev_lesson:
                return True
            prev_progress = LessonProgress.objects.filter(user=user, lesson=prev_lesson).first()
            return prev_progress.status == 'completed' if prev_progress else False

        user = self._get_user()
        if not user:
            return obj.order == 1

        progress = LessonProgress.objects.filter(user=user, lesson=obj).first()
        if progress:
            return progress.status in ['in_progress', 'completed']
        if obj.order == 1:
            return True
        prev_lesson = Lesson.objects.filter(module=obj.module, order__lt=obj.order).order_by('-order').first()
        if not prev_lesson:
            return True
        prev_progress = LessonProgress.objects.filter(user=user, lesson=prev_lesson).first()
        return prev_progress.status == 'completed' if prev_progress else False

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
        fields = ['id', 'title', 'description', 'task_type', 'options', 'correct_option', 'initial_code', 'expected_output', 'difficulty', 'xp_reward', 'order', 'is_completed']

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
