import os
import django

# Set up Django environment
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'src.settings')
django.setup()

from app.models import LandingGoal, LandingFeature, TechTag, LandingReview

def seed_landing_data():
    print("Seeding landing page data...")

    # Clear existing data
    LandingGoal.objects.all().delete()
    LandingFeature.objects.all().delete()
    TechTag.objects.all().delete()
    LandingReview.objects.all().delete()

    # Seed Landing Goals
    goals_data = [
        {"title": "Become a software developer", "description": "Build the skills employers look for in software developers", "icon_emoji": "💻", "order": 1},
        {"title": "Build my own app", "description": "Go from an idea to something you can actually ship", "icon_emoji": "📱", "order": 2},
        {"title": "Advance my career", "description": "Learn practical skills you can apply in your current role", "icon_emoji": "📈", "order": 3},
    ]
    for goal in goals_data:
        LandingGoal.objects.create(**goal)
        print(f"Created goal: {goal['title']}")

    # Seed Landing Features
    features_data = [
        {"label": "LEARN", "title": "Step by step guidance", "description": "Learn at your own pace with clear explanations and structured paths that guide you through every concept", "order": 1},
        {"label": "PRACTICE", "title": "Hands-on practice", "description": "", "order": 2},
        {"label": "BUILD", "title": "Real-world projects", "description": "", "order": 3},
        {"label": "INTERACTIVE", "title": "Learn by doing", "description": "You learn through clear instructions and explanations by writing real code and solving problems like a software developer", "order": 4},
        {"label": "PERSONALIZED", "title": "Get AI-powered guidance", "description": "With precise feedback and hints that adapt to your progress, Codefy helps you keep moving forward when you're stuck", "order": 5},
        {"label": "CAREER-ORIENTED", "title": "Reach professional goals", "description": "Build a portfolio, earn certificates, and join live sessions designed to help you move toward a career in software development", "order": 6},
    ]
    for feat in features_data:
        LandingFeature.objects.create(**feat)
        print(f"Created feature: {feat['title']}")

    # Seed Tech Tags
    techs_data = [
        {"name": "HTML", "icon_content": "5", "icon_color": "#E44D26", "order": 1},
        {"name": "CSS", "icon_content": "3", "icon_color": "#264DE4", "order": 2},
        {"name": "JavaScript", "icon_content": "JS", "icon_color": "#F7DF1E", "is_custom_bg": True, "order": 3},
        {"name": "TypeScript", "icon_content": "📘", "icon_color": "#3178C6", "order": 4},
        {"name": "React", "icon_content": "⚛️", "icon_color": "#61DAFB", "order": 5},
        {"name": "Python", "icon_content": "🐍", "icon_color": "#3776AB", "order": 6},
        {"name": "SQL", "icon_content": "🗄️", "icon_color": "#336791", "order": 7},
        {"name": "Swift", "icon_content": "🦅", "icon_color": "#FA7343", "order": 8},
    ]
    for tech in techs_data:
        TechTag.objects.create(**tech)
        print(f"Created tech tag: {tech['name']}")

    # Seed Reviews
    reviews_data = [
        {"stars": 5, "text": "\"Perfect for beginners, with clear explanations and many practical exercises. It's impossible not to learn. Great app.\"", "author_initials": "ST", "author_name": "Stefano", "avatar_bg_color": "#FFEBEE", "avatar_text_color": "#D32F2F", "order": 1},
        {"stars": 5, "text": "\"What I love so much about the app is how it breaks the subject down into bite-sized pieces, making it very easy to understand.\"", "author_initials": "BS", "author_name": "BroodingSpirit", "avatar_bg_color": "#E3F2FD", "avatar_text_color": "#1976D2", "order": 2},
        {"stars": 5, "text": "\"For those who want to become software developers, this is a must-try application. I would highly recommend this to anyone who's a tech geek.\"", "author_initials": "AX", "author_name": "Arcey XD", "avatar_bg_color": "#F3E5F5", "avatar_text_color": "#7B1FA2", "order": 3},
        {"stars": 5, "text": "\"I love the ability to learn on the GO. A tracking system, a place to practice, a reward system, in short, a full-on immersion into modern learning.\"", "author_initials": "JB", "author_name": "Jean-Pierre", "avatar_bg_color": "#E8F5E9", "avatar_text_color": "#388E3C", "order": 4},
        {"stars": 5, "text": "\"I literally became an expert. The simplicity and great teaching ability are out of the chart.\"", "author_initials": "SA", "author_name": "sadia afrin", "avatar_bg_color": "#FFF8E1", "avatar_text_color": "#FFA000", "order": 5},
        {"stars": 5, "text": "\"The interface is very user-friendly, and the educational part is easy to track, process, digest, and apply.\"", "author_initials": "SF", "author_name": "simply_filip", "avatar_bg_color": "#E0F2F1", "avatar_text_color": "#00796B", "order": 6},
        {"stars": 5, "text": "\"This is an incredible platform for learning full-stack and Python development, and really understanding what you are doing!\"", "author_initials": "SA", "author_name": "Saral Abu", "avatar_bg_color": "#E1F5FE", "avatar_text_color": "#0288D1", "order": 7},
        {"stars": 5, "text": "\"This app makes learning to code very easy. It has an AI tutor for help, and the lessons are practical and show the process in a user-friendly way.\"", "author_initials": "ML", "author_name": "Michael Wendell", "avatar_bg_color": "#FCE4EC", "avatar_text_color": "#C2185B", "order": 8},
    ]
    for review in reviews_data:
        LandingReview.objects.create(**review)
        print(f"Created review by {review['author_name']}")
    
    print("Seeding complete!")

if __name__ == '__main__':
    seed_landing_data()
