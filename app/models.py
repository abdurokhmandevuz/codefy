from django.db import models
from django.contrib.auth.models import User
import uuid

class Course(models.Model):
    title = models.CharField(max_length=200)
    description = models.TextField()
    track_type = models.CharField(max_length=50, choices=[
        ('python', 'Python'),
        ('javascript', 'JavaScript'),
        ('both', 'Web Development')
    ])
    
    def __str__(self):
        return self.title

class Module(models.Model):
    course = models.ForeignKey(Course, on_delete=models.CASCADE, related_name='modules')
    title = models.CharField(max_length=200)
    description = models.TextField()
    order = models.IntegerField(default=1)
    
    def __str__(self):
        return f"{self.order}-Modul: {self.title}"

class Lesson(models.Model):
    module = models.ForeignKey(Module, on_delete=models.CASCADE, related_name='lessons')
    title = models.CharField(max_length=200)
    description = models.TextField(blank=True) # for guided project desc
    content = models.TextField() # HTML or Markdown text for the lesson
    initial_code = models.TextField(blank=True)
    expected_output = models.CharField(max_length=200, blank=True)
    order = models.IntegerField(default=1)
    is_premium = models.BooleanField(default=False)
    is_practice = models.BooleanField(default=False)
    is_supercharge = models.BooleanField(default=False)
    is_guided_project = models.BooleanField(default=False)
    
    def __str__(self):
        return f"Dars {self.order}: {self.title}"

class Badge(models.Model):
    name = models.CharField(max_length=100)
    description = models.TextField()
    icon = models.CharField(max_length=50) # emoji or lucide icon name
    
    def __str__(self):
        return self.name

class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    selected_course = models.ForeignKey(Course, on_delete=models.SET_NULL, null=True, blank=True)
    experience_level = models.CharField(max_length=50, blank=True)
    unlocked_game_levels = models.IntegerField(default=1)
    
    # New fields for XP and real progress
    total_xp = models.IntegerField(default=0)
    streak_days = models.IntegerField(default=0)
    coins = models.IntegerField(default=200)
    hearts = models.IntegerField(default=5)
    league = models.CharField(max_length=50, default='Bronze')
    chosen_path = models.CharField(max_length=100, blank=True)
    avatar = models.ImageField(upload_to='avatars/', null=True, blank=True)
    bio = models.TextField(blank=True)
    
    is_pro = models.BooleanField(default=False)
    onboarding_complete = models.BooleanField(default=False)
    completed_lessons = models.ManyToManyField(Lesson, blank=True)
    earned_badges = models.ManyToManyField(Badge, blank=True)
    
    def __str__(self):
        return f"{self.user.username} Profile"

class LessonProgress(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='lesson_progress')
    lesson = models.ForeignKey(Lesson, on_delete=models.CASCADE)
    progress_percent = models.IntegerField(default=0)
    status = models.CharField(max_length=20, choices=[
        ('locked', 'Locked'),
        ('in_progress', 'In Progress'),
        ('completed', 'Completed')
    ], default='locked')
    
    class Meta:
        unique_together = ('user', 'lesson')

    def __str__(self):
        return f"{self.user.username} - {self.lesson.title}: {self.status}"

class GameLevel(models.Model):
    level_number = models.IntegerField(unique=True)
    title = models.CharField(max_length=200)
    description = models.TextField()
    initial_code = models.TextField()
    expected_output = models.CharField(max_length=200)
    difficulty = models.CharField(max_length=50, default='easy')
    time_limit = models.IntegerField(default=60) # In seconds
    
    def __str__(self):
        return f"Level {self.level_number}: {self.title}"

class UserGameScore(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    level = models.ForeignKey(GameLevel, on_delete=models.CASCADE)
    stars = models.IntegerField(default=0)
    
    class Meta:
        unique_together = ('user', 'level')

class CareerPath(models.Model):
    title = models.CharField(max_length=100)
    description = models.TextField()
    icon_emoji = models.CharField(max_length=10, blank=True)
    svg_code = models.TextField(blank=True)
    is_beginner_friendly = models.BooleanField(default=True)
    order = models.IntegerField(default=1)

    def __str__(self):
        return self.title

class LiveSession(models.Model):
    title = models.CharField(max_length=200)
    datetime = models.DateTimeField()
    timezone_label = models.CharField(max_length=50, default="Asia/Tashkent")
    prerequisites = models.CharField(max_length=300)
    host_name = models.CharField(max_length=100)
    going_count = models.IntegerField(default=0)
    is_past = models.BooleanField(default=False)
    svg_badge = models.TextField(blank=True)

    def __str__(self):
        return self.title

class PracticeCard(models.Model):
    title = models.CharField(max_length=100)
    description = models.TextField()
    icon_emoji = models.CharField(max_length=10)
    order = models.IntegerField(default=1)

    def __str__(self):
        return self.title

# --- New Landing Page Models ---
class LandingGoal(models.Model):
    title = models.CharField(max_length=100)
    description = models.TextField()
    icon_emoji = models.CharField(max_length=10)
    order = models.IntegerField(default=1)

    def __str__(self):
        return self.title

class LandingFeature(models.Model):
    # E.g. "LEARN", "PRACTICE", "INTERACTIVE"
    label = models.CharField(max_length=50)
    title = models.CharField(max_length=100)
    description = models.TextField()
    order = models.IntegerField(default=1)
    
    # Options for rendering custom layout elements in the feature card
    svg_icon = models.TextField(blank=True, null=True)
    is_wide = models.BooleanField(default=False)
    
    def __str__(self):
        return f"{self.label}: {self.title}"

class TechTag(models.Model):
    name = models.CharField(max_length=50)
    # The badge or icon content (e.g. "5", "3", "JS", or emoji "📘")
    icon_content = models.CharField(max_length=20)
    # Background style or color logic can be stored here if needed
    icon_color = models.CharField(max_length=20, default="#000000")
    # For special styling like black background for JS
    is_custom_bg = models.BooleanField(default=False)
    order = models.IntegerField(default=1)

    def __str__(self):
        return self.name

class LandingReview(models.Model):
    stars = models.IntegerField(default=5)
    text = models.TextField()
    author_initials = models.CharField(max_length=5)
    author_name = models.CharField(max_length=50)
    avatar_bg_color = models.CharField(max_length=20, default="#F7F7FB")
    avatar_text_color = models.CharField(max_length=20, default="#1c1d35")
    order = models.IntegerField(default=1)

    def __str__(self):
        return f"Review by {self.author_name}"

# --- New Codefy Full Architecture Models ---

class Achievement(models.Model):
    title = models.CharField(max_length=100)
    description = models.TextField()
    icon = models.CharField(max_length=50) # emoji or lucide icon name

    def __str__(self):
        return self.title

class UserAchievement(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='achievements')
    achievement = models.ForeignKey(Achievement, on_delete=models.CASCADE)
    earned_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.username} - {self.achievement.title}"

class Friendship(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='friendships')
    friend = models.ForeignKey(User, on_delete=models.CASCADE, related_name='friends')
    status = models.CharField(max_length=20, choices=[('pending', 'Pending'), ('accepted', 'Accepted')], default='pending')
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('user', 'friend')

    def __str__(self):
        return f"{self.user.username} -> {self.friend.username} ({self.status})"

class Project(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='projects')
    name = models.CharField(max_length=200)
    share_uuid = models.UUIDField(default=uuid.uuid4, editable=False, unique=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.name

class ProjectFile(models.Model):
    project = models.ForeignKey(Project, on_delete=models.CASCADE, related_name='files')
    name = models.CharField(max_length=100)
    content = models.TextField(blank=True)
    language = models.CharField(max_length=50, default='python')

    def __str__(self):
        return f"{self.project.name} - {self.name}"

# --- Codefy Community Models ---

class BannedWord(models.Model):
    word = models.CharField(max_length=100, unique=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.word

class Discussion(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='discussions')
    lesson = models.ForeignKey(Lesson, on_delete=models.SET_NULL, null=True, blank=True, related_name='discussions')
    title = models.CharField(max_length=200)
    body = models.TextField()
    code_snippet = models.TextField(blank=True)
    code_language = models.CharField(max_length=50, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    likes_count = models.IntegerField(default=0)
    
    def __str__(self):
        return self.title

class Comment(models.Model):
    discussion = models.ForeignKey(Discussion, on_delete=models.CASCADE, related_name='comments')
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='comments')
    body = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    is_accepted_answer = models.BooleanField(default=False)
    
    def __str__(self):
        return f"Comment by {self.user.username} on {self.discussion.title}"

class Like(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='likes')
    discussion = models.ForeignKey(Discussion, on_delete=models.CASCADE, null=True, blank=True, related_name='likes')
    comment = models.ForeignKey(Comment, on_delete=models.CASCADE, null=True, blank=True, related_name='likes')
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        # A user can only like a specific discussion or comment once.
        # This is hard to enforce perfectly with unique_together if either can be null,
        # but we handle the logic in views.
        pass

    def __str__(self):
        return f"Like by {self.user.username}"

class Report(models.Model):
    REASON_CHOICES = [
        ('spam', 'Spam / Reklama'),
        ('inappropriate', 'Haqorat / Nojo\'ya so\'zlar'),
        ('off_topic', 'Mavzudan tashqari'),
        ('other', 'Boshqa'),
    ]
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='reports')
    discussion = models.ForeignKey(Discussion, on_delete=models.CASCADE, null=True, blank=True)
    comment = models.ForeignKey(Comment, on_delete=models.CASCADE, null=True, blank=True)
    reason = models.CharField(max_length=50, choices=REASON_CHOICES)
    details = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    is_resolved = models.BooleanField(default=False)

    def __str__(self):
        return f"Report by {self.user.username} ({self.reason})"
