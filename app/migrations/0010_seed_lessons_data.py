from django.db import migrations

def seed_lessons(apps, schema_editor):
    Course = apps.get_model('app', 'Course')
    Module = apps.get_model('app', 'Module')
    Lesson = apps.get_model('app', 'Lesson')
    
    course, _ = Course.objects.get_or_create(
        title='Full-Stack Developer Career Path',
        defaults={'description': 'Comprehensive path from zero to full-stack web developer.', 'track_type': 'both'}
    )
    module, _ = Module.objects.get_or_create(
        course=course,
        title='Intro to Web Development & Python',
        defaults={'description': 'Create webpages using HTML and CSS, master Python basics.', 'order': 1}
    )
    
    Lesson.objects.filter(module=module).delete()
    
    Lesson.objects.create(
        module=module,
        title='HTML va Python Asoslari',
        type='theory',
        content='HTML (HyperText Markup Language) — veb-sahifalar tuzilishini yaratuvchi standart tildir. Python esa eng ommabop dasturlash tili bo\'lib, print() orqali ekranga matn chiqariladi.',
        options=['print()', 'input()', 'len()', 'str()'],
        correct_option='print()',
        initial_code='print(\'Hello World\')',
        expected_output='Hello World',
        xp_reward=25,
        coins_reward=15,
        order=1
    )
    
    Lesson.objects.create(
        module=module,
        title='Matnlar va Sarlavhalar',
        type='theory',
        content='HTMLda sarlavhalar <h1> dan <h6> gacha teglar bilan beriladi. Python-da matnlar \'str\' (string) ma\'lumot turiga kiradi.',
        options=['str', 'int', 'float', 'bool'],
        correct_option='str',
        initial_code='a = 5\nb = 10\nprint(a + b)',
        expected_output='15',
        xp_reward=25,
        coins_reward=15,
        order=2
    )

    Lesson.objects.create(
        module=module,
        title='O\'zgaruvchilar va Shartlar',
        type='theory',
        content='O\'zgaruvchilar ma\'lumotlarni saqlaydi. Python\'da \'if\' iborasi yordamida shartlar tekshiriladi.',
        options=['if', 'for', 'while', 'def'],
        correct_option='if',
        initial_code='x = 10\nif x > 5:\n    print(\'Katta\')',
        expected_output='Katta',
        xp_reward=30,
        coins_reward=20,
        order=3
    )

    Lesson.objects.create(
        module=module,
        title='Linktree Mini Loyihasi',
        type='theory',
        description='Shaxsiy havola va ijtimoiy tarmoqlar sahifangizni yaratuvchi mini loyiha.',
        content='Tabriklaymiz! Ushbu amaliy loyihada HTML va Python yordamida birinchi shaxsiy veb-havola kartangizni yaratasiz.',
        options=['html', 'css', 'python', 'barchasi'],
        correct_option='barchasi',
        initial_code='name = \'Codefy\'\nprint(\'Welcome to \' + name)',
        expected_output='Welcome to Codefy',
        xp_reward=50,
        coins_reward=30,
        order=4,
        is_guided_project=True
    )

class Migration(migrations.Migration):

    dependencies = [
        ('app', '0009_create_admin_user'),
    ]

    operations = [
        migrations.RunPython(seed_lessons),
    ]
