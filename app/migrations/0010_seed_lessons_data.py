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
    
    lessons = [
        {
            "order": 1,
            "title": "HTML va Python Asoslari",
            "content": "HTML (HyperText Markup Language) -- veb-sahifalar tuzilishini yaratuvchi standart tildir. Python esa zamonaviy va sodda dasturlash tili bo'lib, print() funksiyasi ekranga matn chiqaradi.",
            "options": ["print()", "input()", "len()", "type()"],
            "correct_option": "print()",
            "initial_code": "print('Salom Codefy!')",
            "expected_output": "Salom Codefy!",
            "xp_reward": 15,
            "coins_reward": 10,
        },
        {
            "order": 2,
            "title": "O'zgaruvchilar va Ma'lumot Turlari",
            "content": "Python tilida o'zgaruvchilar ma'lumotlarni saqlash uchun idish hisoblanadi. Asosiy turlar: str (matn), int (butun son), float (o'nlik son).",
            "options": ["str", "int", "float", "bool"],
            "correct_option": "str",
            "initial_code": "a = 15\nb = 25\nprint(a + b)",
            "expected_output": "40",
            "xp_reward": 15,
            "coins_reward": 10,
        },
        {
            "order": 3,
            "title": "HTML Matnlar va Sarlavhalar",
            "content": "HTMLda sarlavhalar <h1> dan <h6> gacha teglar bilan beriladi. <h1> eng katta sarlavha, <h6> eng kichigi. Paragraflar <p> tegi bilan yoziladi.",
            "options": ["<h1>", "<head>", "<p>", "title"],
            "correct_option": "<h1>",
            "initial_code": "name = 'Python'\nprint('Men ' + name + ' o\'rganyapman')",
            "expected_output": "Men Python o'rganyapman",
            "xp_reward": 20,
            "coins_reward": 15,
        },
        {
            "order": 4,
            "title": "Shart Operatorlari (if, else)",
            "content": "if va else kalit so'zlari yordamida dasturda mantiqiy shartlar tekshiriladi va ma'lum bir kod bloki bajariladi.",
            "options": ["if", "for", "def", "import"],
            "correct_option": "if",
            "initial_code": "ball = 90\nif ball >= 80:\n    print('A\'lo')",
            "expected_output": "A'lo",
            "xp_reward": 20,
            "coins_reward": 15,
        },
        {
            "order": 5,
            "title": "Ro'yxatlar (Lists)",
            "content": "Python'da ro'yxatlar bir nechta elementni bitta o'zgaruvchida saqlash imkonini beradi. Ro'yxat kvadrat qavslar [] bilan yaratiladi.",
            "options": ["[]", "{}", "()", "<>"],
            "correct_option": "[]",
            "initial_code": "mevalar = ['Olma', 'Banan', 'Uzum']\nprint(mevalar[0])",
            "expected_output": "Olma",
            "xp_reward": 25,
            "coins_reward": 15,
        },
        {
            "order": 6,
            "title": "Sikllar (for loop)",
            "content": "for sikli ro'yxat yoki ketma-ketlikdagi har bir element bo'ylab takrorlanuvchi amallarni bajarish uchun ishlatiladi.",
            "options": ["for", "while", "if", "range"],
            "correct_option": "for",
            "initial_code": "for i in range(3):\n    print('Codefy')",
            "expected_output": "Codefy\nCodefy\nCodefy",
            "xp_reward": 25,
            "coins_reward": 20,
        },
        {
            "order": 7,
            "title": "Funksiyalar (def)",
            "content": "Funksiya -- muayyan vazifani bajaradigan va qayta ishlatiladigan kod blokidir. U def kalit so'zi bilan e'lon qilinadi.",
            "options": ["def", "func", "function", "create"],
            "correct_option": "def",
            "initial_code": "def salomlashtir(ism):\n    print('Salom ' + ism)\nsalomlashtir('Ali')",
            "expected_output": "Salom Ali",
            "xp_reward": 30,
            "coins_reward": 20,
        },
        {
            "order": 8,
            "title": "HTML Havolalar va Rasmlar",
            "content": "HTMLda havolalar <a> tegi bilan, rasmlar esa <img> tegi bilan sahifaga joylashtiriladi.",
            "options": ["<a>", "<img>", "<link>", "<src>"],
            "correct_option": "<a>",
            "initial_code": "yosh = 18\nif yosh >= 18:\n    print('Ruxsat berildi')",
            "expected_output": "Ruxsat berildi",
            "xp_reward": 30,
            "coins_reward": 20,
        },
        {
            "order": 9,
            "title": "Lug'atlar (Dictionaries)",
            "content": "Lug'at (Dictionary) kalit va qiymat (key: value) juftliklarini figura qavslar {} yordamida saqlaydi.",
            "options": ["{}", "[]", "()", "set()"],
            "correct_option": "{}",
            "initial_code": "user = {'ism': 'Otabek', 'yosh': 20}\nprint(user['ism'])",
            "expected_output": "Otabek",
            "xp_reward": 35,
            "coins_reward": 25,
        },
        {
            "order": 10,
            "title": "Mini Loyiha: Shaxsiy Profil Veb-Sahifasi",
            "content": "Tabriklaymiz! Siz 10-darsga yetib keldingiz. Ushbu mini loyihada HTML va Python bilimlaridan foydalanib, foydalanuvchi profilini yaratasiz.",
            "options": ["HTML + Python", "Faqat CSS", "Faqat SQL", "Hech qaysi"],
            "correct_option": "HTML + Python",
            "initial_code": "ism = 'Codefy O\'quvchisi'\nprint('Tabriklaymiz, ' + ism + '!')",
            "expected_output": "Tabriklaymiz, Codefy O'quvchisi!",
            "xp_reward": 50,
            "coins_reward": 30,
            "is_guided_project": True
        }
    ]
    
    for l_data in lessons:
        Lesson.objects.create(
            module=module,
            type='theory',
            **l_data
        )

class Migration(migrations.Migration):

    dependencies = [
        ('app', '0009_create_admin_user'),
    ]

    operations = [
        migrations.RunPython(seed_lessons),
    ]
