import os
import django
from datetime import datetime, timedelta
from django.utils import timezone

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'src.settings')
django.setup()

from app.models import Course, Module, Lesson, CareerPath, LiveSession, PracticeCard
from django.contrib.auth.models import User

# Clear existing data to avoid duplicates during test
CareerPath.objects.all().delete()
LiveSession.objects.all().delete()
PracticeCard.objects.all().delete()
Course.objects.all().delete()

print("Seeding Career Paths...")
CareerPath.objects.create(
    title="Full-Stack Developer",
    description="Become a full-stack developer: Learn HTML, CSS, JavaScript, and React as well as NodeJS, Express, and SQL",
    icon_emoji="🎓",
    svg_code='''<svg width="80" height="80" viewBox="0 0 100 100" fill="none"><rect x="25" y="60" width="10" height="20" rx="5" fill="#69688c"/><rect x="65" y="60" width="10" height="20" rx="5" fill="#69688c"/><rect x="15" y="25" width="70" height="60" rx="20" fill="#e8e8f0"/><rect x="25" y="35" width="50" height="35" rx="10" fill="#0b0b1a"/><path d="M35 48 C35 45,32 45,32 48 C32 51,35 51,35 48Z" fill="#00d4ff"/><path d="M65 48 C65 45,62 45,62 48 C62 51,65 51,65 48Z" fill="#00d4ff"/><path d="M46 54 L54 54 M50 50 L50 58" stroke="#00d4ff" stroke-width="2.5" stroke-linecap="round"/></svg>''',
    is_beginner_friendly=True,
    order=1
)
CareerPath.objects.create(
    title="Front-End Developer",
    description="Unlock Web Development: dive deep into HTML, CSS, and JavaScript, and conquer React",
    icon_emoji="💻",
    svg_code='''<svg width="80" height="80" viewBox="0 0 100 100" fill="none"><rect x="25" y="60" width="10" height="20" rx="5" fill="#69688c"/><rect x="65" y="60" width="10" height="20" rx="5" fill="#69688c"/><rect x="15" y="25" width="70" height="60" rx="20" fill="#e8e8f0"/><rect x="25" y="35" width="50" height="35" rx="10" fill="#0b0b1a"/><path d="M32 48 Q35 44 38 48" stroke="#00d4ff" stroke-width="3" stroke-linecap="round"/><path d="M62 48 Q65 44 68 48" stroke="#00d4ff" stroke-width="3" stroke-linecap="round"/><path d="M50 52 L53 55 L50 58 L47 55 Z" fill="#00d4ff"/></svg>''',
    is_beginner_friendly=True,
    order=2
)
CareerPath.objects.create(
    title="Python Developer",
    description="Become a Python developer: Learn the all-purpose language Python and build sophisticated programs",
    icon_emoji="🐍",
    svg_code='''<svg width="80" height="80" viewBox="0 0 100 100" fill="none"><rect x="25" y="60" width="10" height="20" rx="5" fill="#69688c"/><rect x="65" y="60" width="10" height="20" rx="5" fill="#69688c"/><rect x="15" y="25" width="70" height="60" rx="20" fill="#e8e8f0"/><rect x="25" y="35" width="50" height="35" rx="10" fill="#0b0b1a"/><path d="M35 48 C35 45,32 45,32 48 C32 51,35 51,35 48Z" fill="#00d4ff"/><path d="M65 48 C65 45,62 45,62 48 C62 51,65 51,65 48Z" fill="#00d4ff"/><rect x="44" y="55" width="12" height="4" rx="2" fill="#00d4ff"/></svg>''',
    is_beginner_friendly=True,
    order=3
)
CareerPath.objects.create(
    title="Back-End Developer",
    description="Become a back-end developer: Learn JavaScript, understand NodeJS, build backends with Express, and master SQL",
    icon_emoji="⚙️",
    svg_code='''<svg width="80" height="80" viewBox="0 0 100 100" fill="none"><rect x="25" y="60" width="10" height="20" rx="5" fill="#69688c"/><rect x="65" y="60" width="10" height="20" rx="5" fill="#69688c"/><rect x="15" y="25" width="70" height="60" rx="20" fill="#e8e8f0"/><rect x="25" y="35" width="50" height="35" rx="10" fill="#0b0b1a"/><path d="M35 48 C35 45,32 45,32 48 C32 51,35 51,35 48Z" fill="#00d4ff"/><path d="M65 48 C65 45,62 45,62 48 C62 51,65 51,65 48Z" fill="#00d4ff"/><path d="M43 55 Q50 60 57 55" stroke="#00d4ff" stroke-width="3" stroke-linecap="round"/></svg>''',
    is_beginner_friendly=True,
    order=4
)

print("Seeding Live Sessions...")
# Hardcode fixed datetime or delta from now
now = timezone.now()
LiveSession.objects.create(
    title="Dynamic Webpages - EU",
    datetime=now + timedelta(days=2),
    timezone_label="Asia/Tashkent",
    prerequisites="HTML and JavaScript fundamentals",
    host_name="Pam",
    going_count=4,
    svg_badge='''<svg width="60" height="60" viewBox="0 0 100 100"><rect x="10" y="20" width="40" height="40" fill="#E44D26" rx="8"/><text x="30" y="45" fill="white" font-size="20" font-weight="bold" font-family="sans-serif" text-anchor="middle">5</text><rect x="40" y="40" width="40" height="40" fill="#F7DF1E" rx="8"/><text x="60" y="65" fill="black" font-size="16" font-weight="bold" font-family="sans-serif" text-anchor="middle">JS</text></svg>'''
)
LiveSession.objects.create(
    title="Dynamic Webpages - US",
    datetime=now + timedelta(days=4),
    timezone_label="Asia/Tashkent",
    prerequisites="HTML and JavaScript fundamentals",
    host_name="Pam",
    going_count=1,
    svg_badge='''<svg width="60" height="60" viewBox="0 0 100 100"><rect x="10" y="20" width="40" height="40" fill="#E44D26" rx="8"/><text x="30" y="45" fill="white" font-size="20" font-weight="bold" font-family="sans-serif" text-anchor="middle">5</text><rect x="40" y="40" width="40" height="40" fill="#F7DF1E" rx="8"/><text x="60" y="65" fill="black" font-size="16" font-weight="bold" font-family="sans-serif" text-anchor="middle">JS</text></svg>'''
)

print("Seeding Practice Cards...")
PracticeCard.objects.create(title="Real-life scenarios", description="Engage with real-life coding scenarios to apply your knowledge in practical situations", icon_emoji="💼", order=1)
PracticeCard.objects.create(title="Review and reinforce", description="Revisit past topics to solidify your understanding and ensure long-term retention", icon_emoji="🔄", order=2)
PracticeCard.objects.create(title="Improve problem-solving", description="Enhance your skills with challenging exercises", icon_emoji="💡", order=3)

print("Seeding Course / Dashboard data...")
c = Course.objects.create(title="Full-Stack Developer Career Path", description="Comprehensive path from zero to full-stack web developer.", track_type="both")
m = Module.objects.create(course=c, title="Intro to Web Development & Python", description="Create webpages using HTML and CSS, master Python basics.", order=1)

Lesson.objects.create(
    module=m,
    title="Discovering HTML and Tags",
    type="theory",
    content="HTML (HyperText Markup Language) — veb-sahifalar tuzilishini yaratuvchi standart tildir. Teglar yordamida kontent tuzilmasi beriladi.",
    xp_reward=10,
    coins_reward=5,
    order=1
)
Lesson.objects.create(
    module=m,
    title="Python Print Test",
    type="test",
    content="Python tilida matnni ekranga chiqarish uchun qaysi funksiya ishlatiladi?",
    options=["print()", "input()", "len()", "str()"],
    correct_option="print()",
    xp_reward=15,
    coins_reward=10,
    order=2
)
Lesson.objects.create(
    module=m,
    title="Hello World Coding Challenge",
    type="code",
    content="Chiqaruvchi dastur yozing va 'Hello World' chop eting.",
    initial_code="print('Hello World')",
    expected_output="Hello World",
    xp_reward=20,
    coins_reward=15,
    order=3,
    is_practice=True,
    is_supercharge=True
)
Lesson.objects.create(
    module=m,
    title="Structuring Text with Tags",
    type="theory",
    content="HTMLda sarlavhalar <h1> dan <h6> gacha bo'lgan teglar bilan aniqlanadi. <h1> eng katta sarlavhadir.",
    xp_reward=10,
    coins_reward=5,
    order=4
)
Lesson.objects.create(
    module=m,
    title="Data Types Quiz",
    type="test",
    content="Python-da 'Hello' qaysi ma'lumot turiga kiradi?",
    options=["str", "int", "float", "bool"],
    correct_option="str",
    xp_reward=15,
    coins_reward=10,
    order=5
)
Lesson.objects.create(
    module=m,
    title="Sum Calculation Code Challenge",
    type="code",
    content="5 va 10 sonlarining yig'indisini ekranga chiqaring.",
    initial_code="a = 5\nb = 10\nprint(a + b)",
    expected_output="15",
    xp_reward=25,
    coins_reward=15,
    order=6,
    is_practice=True,
    is_supercharge=True
)
Lesson.objects.create(
    module=m,
    title="Linktree",
    type="theory",
    description="Get ready to build your very own Linktree-style page, where you can showcase all your socials and other links you care about in one spot.",
    content="Linktree loyihasini yaratish bo'yicha ko'rsatmalar...",
    xp_reward=50,
    coins_reward=30,
    order=7,
    is_guided_project=True
)

print("Seeding default user...")
user, created = User.objects.get_or_create(username="demo", defaults={"email": "demo@codefy.uz"})
if created:
    user.set_password("password123")
    user.save()
from app.models import UserProfile
profile, _ = UserProfile.objects.get_or_create(user=user)

print("Seed complete.")
