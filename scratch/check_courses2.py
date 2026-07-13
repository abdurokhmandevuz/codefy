import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'src.settings')
django.setup()

from django.contrib.auth.models import User
from app.models import Course, UserProfile

print("All Courses:")
for c in Course.objects.all():
    print(f"Course: {c.title} (ID: {c.id}) - Modules count: {c.modules.count()}")

print("\nUsers and their selected courses:")
for u in User.objects.all():
    profile = UserProfile.objects.filter(user=u).first()
    if profile:
        c = profile.selected_course
        print(f"User: {u.username}, Course: {c.title if c else 'None'} (ID: {c.id if c else 'None'})")
