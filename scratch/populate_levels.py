from main.models import GameLevel

if not GameLevel.objects.exists():
    GameLevel.objects.create(
        level_id=1,
        title="O'zgaruvchini chop eting",
        description="Quyidagi kodda xato bor. 'Hello World!' o'rniga 'Hello Codefy!' chop etilishi kerak. Xatoni toping va to'g'rilang.",
        initial_code="message = 'Hello World!'\nprint(message)",
        expected_output="Hello Codefy!"
    )
    
    GameLevel.objects.create(
        level_id=2,
        title="If-else tuzilmasi",
        description="Kod `age` o'zgaruvchisi 18 dan katta bo'lsa 'Katta', aks holda 'Kichik' chiqarishi kerak. Lekin hozir xato ishlayapti.",
        initial_code="age = 20\nif age < 18:\n    print('Katta')\nelse:\n    print('Kichik')",
        expected_output="Katta"
    )

    print("Levels created")
