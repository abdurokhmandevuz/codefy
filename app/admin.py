from django.contrib import admin
from .models import (
    Course, Module, Lesson, Badge, UserProfile, GameLevel, UserGameScore,
    LessonProgress, CareerPath, LiveSession, PracticeCard, PracticeTask, PracticeTaskProgress, LandingGoal, 
    LandingFeature, TechTag, LandingReview, Achievement, UserAchievement, 
    Friendship, Project, ProjectFile, BannedWord, Discussion, Comment, Like, Report
)

@admin.register(UserProfile)
class UserProfileAdmin(admin.ModelAdmin):
    list_display = ('user', 'coins', 'streak_days', 'total_xp', 'league', 'chosen_path')
    list_filter = ('league', 'chosen_path', 'is_pro')
    search_fields = ('user__username', 'user__email')
    readonly_fields = ('user',)
    list_per_page = 25

class ModuleInline(admin.TabularInline):
    model = Module
    extra = 1
    fields = ('title', 'order')

@admin.register(Course)
class CourseAdmin(admin.ModelAdmin):
    list_display = ('title', 'track_type', 'module_count')
    list_filter = ('track_type',)
    search_fields = ('title',)
    inlines = [ModuleInline]

    def module_count(self, obj):
        return obj.modules.count()
    module_count.short_description = "Modullar soni"

class LessonInline(admin.TabularInline):
    model = Lesson
    extra = 1
    fields = ('title', 'order', 'is_premium', 'is_practice')

@admin.register(Module)
class ModuleAdmin(admin.ModelAdmin):
    list_display = ('title', 'course', 'order')
    list_filter = ('course',)
    search_fields = ('title', 'course__title')
    ordering = ('course', 'order')
    inlines = [LessonInline]

@admin.register(Lesson)
class LessonAdmin(admin.ModelAdmin):
    list_display = ('title', 'module', 'order', 'is_premium', 'is_practice')
    list_filter = ('module__course', 'is_premium', 'is_practice')
    search_fields = ('title', 'content')
    ordering = ('module', 'order')

@admin.register(LessonProgress)
class LessonProgressAdmin(admin.ModelAdmin):
    list_display = ('user', 'lesson', 'status', 'progress_percent')
    list_filter = ('status',)
    search_fields = ('user__username', 'lesson__title')

class ProjectFileInline(admin.TabularInline):
    model = ProjectFile
    extra = 0
    fields = ('name', 'language')

@admin.register(Project)
class ProjectAdmin(admin.ModelAdmin):
    list_display = ('name', 'user', 'created_at', 'updated_at', 'file_count')
    search_fields = ('name', 'user__username')
    readonly_fields = ('share_uuid', 'created_at', 'updated_at')
    inlines = [ProjectFileInline]

    def file_count(self, obj):
        return obj.files.count()
    file_count.short_description = "Fayllar soni"

@admin.register(ProjectFile)
class ProjectFileAdmin(admin.ModelAdmin):
    list_display = ('name', 'project', 'language')
    list_filter = ('language',)
    search_fields = ('name', 'project__name')

@admin.register(Discussion)
class DiscussionAdmin(admin.ModelAdmin):
    list_display = ('title', 'user', 'lesson', 'likes_count', 'created_at', 'comment_count')
    list_filter = ('created_at',)
    search_fields = ('title', 'body', 'user__username')
    date_hierarchy = 'created_at'

    def comment_count(self, obj):
        return obj.comments.count()
    comment_count.short_description = "Izohlar soni"

@admin.register(BannedWord)
class BannedWordAdmin(admin.ModelAdmin):
    list_display = ('word', 'created_at')
    search_fields = ('word',)

@admin.register(Achievement)
class AchievementAdmin(admin.ModelAdmin):
    list_display = ('title', 'icon')
    search_fields = ('title',)

@admin.register(UserAchievement)
class UserAchievementAdmin(admin.ModelAdmin):
    list_display = ('user', 'achievement', 'earned_at')
    list_filter = ('achievement',)
    search_fields = ('user__username', 'achievement__title')

@admin.register(Friendship)
class FriendshipAdmin(admin.ModelAdmin):
    list_display = ('user', 'friend', 'status', 'created_at')
    list_filter = ('status',)
    search_fields = ('user__username', 'friend__username')

@admin.register(PracticeCard)
class PracticeCardAdmin(admin.ModelAdmin):
    list_display = ('title', 'order')
    ordering = ('order',)

@admin.register(PracticeTask)
class PracticeTaskAdmin(admin.ModelAdmin):
    list_display = ('title', 'card', 'difficulty', 'xp_reward', 'order')
    list_filter = ('card', 'difficulty')
    search_fields = ('title', 'description')

@admin.register(PracticeTaskProgress)
class PracticeTaskProgressAdmin(admin.ModelAdmin):
    list_display = ('user', 'task', 'is_completed', 'completed_at')
    list_filter = ('is_completed',)
    search_fields = ('user__username', 'task__title')

@admin.register(LiveSession)
class LiveSessionAdmin(admin.ModelAdmin):
    list_display = ('title', 'datetime', 'host_name', 'is_past', 'going_count')
    list_filter = ('is_past',)
    search_fields = ('title', 'host_name')

@admin.register(Comment)
class CommentAdmin(admin.ModelAdmin):
    list_display = ('user', 'discussion', 'is_accepted_answer', 'created_at')
    list_filter = ('is_accepted_answer', 'created_at')
    search_fields = ('body', 'user__username')

@admin.register(Like)
class LikeAdmin(admin.ModelAdmin):
    list_display = ('user', 'created_at')

@admin.register(Report)
class ReportAdmin(admin.ModelAdmin):
    list_display = ('user', 'reason', 'is_resolved', 'created_at')
    list_filter = ('reason', 'is_resolved')
    search_fields = ('user__username', 'details')

admin.site.register(Badge)
admin.site.register(GameLevel)
admin.site.register(UserGameScore)
admin.site.register(CareerPath)
admin.site.register(LandingGoal)
admin.site.register(LandingFeature)
admin.site.register(TechTag)
admin.site.register(LandingReview)

# ==========================================
# CUSTOM ADMIN MENU GROUPING (MONKEY-PATCH)
# ==========================================
def get_custom_app_list(self, request, app_label=None):
    app_dict = self._build_app_dict(request)
    
    if not app_label and 'app' in app_dict:
        app_models = app_dict['app']['models']
        
        # Define categories and their models
        categories = {
            "1. Darslar va O'quv (Kurslar)": ['Course', 'Module', 'Lesson', 'PracticeCard', 'PracticeTask', 'LiveSession', 'CareerPath'],
            "2. Foydalanuvchilar va Yutuqlar": ['UserProfile', 'LessonProgress', 'PracticeTaskProgress', 'Achievement', 'UserAchievement', 'Badge', 'Friendship'],
            "3. Hamjamiyat va Muhokamalar": ['Discussion', 'Comment', 'Like', 'Report', 'BannedWord'],
            "4. Loyihalar va O'yinlar": ['Project', 'ProjectFile', 'GameLevel', 'UserGameScore'],
            "5. Landing Sahifa (Asosiy)": ['LandingGoal', 'LandingFeature', 'TechTag', 'LandingReview'],
        }
        
        new_apps = []
        for cat_name, model_names in categories.items():
            cat_models = [m for m in app_models if m['object_name'] in model_names]
            if cat_models:
                new_apps.append({
                    'name': cat_name,
                    'app_label': f'custom_{cat_name}',
                    'app_url': '/admin/app/', 
                    'has_module_perms': True,
                    'models': cat_models
                })
        
        del app_dict['app']
        
        app_list = list(app_dict.values()) + new_apps
        app_list.sort(key=lambda x: x['name'].lower())
        return app_list
    
    elif app_label:
        return [app_dict.get(app_label, {})]
    
    return sorted(app_dict.values(), key=lambda x: x['name'].lower())

# Monkey patch the get_app_list method of the default AdminSite
admin.site.__class__.get_app_list = get_custom_app_list
