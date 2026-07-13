import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'src.settings')
django.setup()

from django.contrib.auth.models import User
from app.models import Course, Module, Lesson, UserProfile

for u in User.objects.all():
    profile = UserProfile.objects.filter(user=u).first()
    if profile:
        course = profile.selected_course
        print(f"User: {u.username}, Course: {course.title if course else 'None'}")
        if course:
            modules = course.modules.all()
            print(f"  Modules: {modules.count()}")
            for m in modules:
                print(f"    - {m.title}: {m.lessons.count()} lessons")

print("\nAll Courses:")
for c in Course.objects.all():
    print(f"Course: {c.title}")
    modules = c.modules.all()
    print(f"  Modules: {modules.count()}")
    for m in modules:
        print(f"    - {m.title}: {m.lessons.count()} lessons")
