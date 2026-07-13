import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'codefy_project.settings')
django.setup()

from main.models import GameLevel

def populate_game():
    level1, created = GameLevel.objects.get_or_create(
        level_number=1,
        defaults={
            'title': "Yo'qolgan Qavslar",
            'description': "Quyidagi kod xato bilan yozilgan. U ismlarni ekranga chiqarishi kerak. 60 soniya ichida xatoni topib to'g'rilang!",
            'initial_code': 'def say_hello(name):\n    print"Salom " + name\n\nsay_hello("Ali")',
            'expected_output': 'Salom Ali\n',
            'difficulty': 'easy',
            'time_limit': 60
        }
    )
    if not created:
        level1.initial_code = 'def say_hello(name):\n    print"Salom " + name\n\nsay_hello("Ali")'
        level1.expected_output = 'Salom Ali\n'
        level1.time_limit = 60
        level1.save()

    print("Bug Hunter o'yini darajasi bazaga yozildi!")

if __name__ == '__main__':
    populate_game()
