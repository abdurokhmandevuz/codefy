import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'src.settings')
django.setup()

from app.models import Course, Module, Lesson

# 1. Update Course
for c in Course.objects.all():
    if c.title == 'Full-Stack Developer Career Path':
        c.title = "Full-Stack Dasturchi (Karyera yo'li)"
        c.save()
    elif c.title == 'Python Asoslari':
        c.title = "Python Dasturlash Asoslari"
        c.save()

# 2. Update Modules
for m in Module.objects.all():
    if "Intro to Web Development" in m.title:
        m.title = "Veb dasturlashga kirish (HTML va CSS)"
        m.save()
    elif "Advanced Python" in m.title:
        m.title = "Murakkab Python"
        m.save()

# 3. Check Lessons
for l in Lesson.objects.all():
    if l.title == "Discovering HTML and Tags":
        l.title = "HTML va Teglar bilan tanishuv"
        l.save()
    elif l.title == "Structuring Text with Tags":
        l.title = "Matnni teglar bilan tuzish"
        l.save()
    elif l.title == "HTML Basics 1":
        l.title = "HTML Asoslari 1"
        l.save()
    elif l.title == "Creating Links":
        l.title = "Siltamalar (Linklar) yaratish"
        l.save()
    elif l.title == "Adding Images":
        l.title = "Rasmlar qo'shish"
        l.save()
    elif l.title == "HTML Basics 2":
        l.title = "HTML Asoslari 2"
        l.save()
    elif l.title == "Linktree":
        l.title = "Linktree loyihasi"
        l.save()

print("Database translated!")
