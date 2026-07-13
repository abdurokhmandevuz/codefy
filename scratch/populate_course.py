from main.models import Course, Module, Lesson

# Create Course
course, created = Course.objects.get_or_create(
    title="Python 3 ni o'rganish",
    defaults={
        'description': "Jahonning eng mashhur tilida dasturlash asoslarini o'rganing.",
        'track_type': "python"
    }
)

# Module 1
mod1, _ = Module.objects.get_or_create(
    course=course, order=1, 
    defaults={'title': "Salom Dunyo!", 'description': "Print() funksiyasi va stringlar bilan ishlashni o'rganamiz."}
)

Lesson.objects.get_or_create(
    module=mod1, order=1,
    defaults={
        'title': "Birinchi kod",
        'content': "<p>Python'da matn ekranga chiqarish uchun <code>print()</code> funksiyasidan foydalaniladi.</p><p>Vazifa: Ekranga 'Salom Dunyo!' deb chiqaring.</p>",
        'initial_code': "# Shu yerga kodingizni yozing\n",
        'expected_output': "Salom Dunyo!"
    }
)

Lesson.objects.get_or_create(
    module=mod1, order=2,
    defaults={
        'title': "String (Matn)",
        'content': "<p>Matnlar doimo qo'shtirnoq yoki bittalik tirnoq ichida yoziladi. Masalan: <code>'Codefy'</code></p><p>Vazifa: 'Men Python organayapman' so'zini chiqaring.</p>",
        'initial_code': "print()\n",
        'expected_output': "Men Python organayapman"
    }
)

# Module 2
mod2, _ = Module.objects.get_or_create(
    course=course, order=2,
    defaults={'title': "O'zgaruvchilar va Ma'lumot turlari", 'description': "Dastur xotirasida ma'lumotlarni qanday saqlash va ulardan foydalanish."}
)

Lesson.objects.get_or_create(
    module=mod2, order=1,
    defaults={
        'title': "O'zgaruvchilar yaratish",
        'content': "<p>O'zgaruvchi xuddi quti kabi ishlaydi. <code>ism = 'Ali'</code> deb yozsak xotirada joy ajratadi.</p><p>Vazifa: `yosh` degan o'zgaruvchi yarating va unga 25 ni tenglang. So'ng print(yosh) qiling.</p>",
        'initial_code': "",
        'expected_output': "25"
    }
)

print("Course, Modules and Lessons populated successfully!")
