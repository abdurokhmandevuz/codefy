import os
import sys

sys.path.append(os.path.dirname(__file__))

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "src.settings")
import django
django.setup()

from rest_framework.test import APIRequestFactory
from app.api_views import get_lesson_detail, complete_lesson
from app.models import Lesson, UserProfile
from django.contrib.auth.models import User

def main():
    print("=== Verification Script for Milestone 1 ===")
    factory = APIRequestFactory()
    user = User.objects.first()
    if not user:
        user = User.objects.create(username="verify_user")
    profile, _ = UserProfile.objects.get_or_create(user=user)

    lessons = Lesson.objects.all().order_by('order')
    if not lessons.exists():
        print("ERROR: No lessons found in DB. Run seed_data.py first.")
        sys.exit(1)

    first_lesson = lessons[0]
    print(f"\n1. Testing GET /api/v1/lesson/{first_lesson.id}/")
    request_get = factory.get(f'/api/v1/lesson/{first_lesson.id}/')
    response_get = get_lesson_detail(request_get, lesson_id=first_lesson.id)
    print("STATUS:", response_get.status_code)
    print("DATA:", response_get.data)

    assert response_get.status_code == 200, "GET request failed!"
    data = response_get.data
    for key in ['id', 'title', 'type', 'content', 'options', 'correct_option', 'xp_reward', 'coins_reward', 'is_unlocked', 'is_completed']:
        assert key in data, f"Missing key '{key}' in GET response!"
    print("[OK] GET endpoint contract verified successfully.")

    print(f"\n2. Testing POST /api/v1/lesson/{first_lesson.id}/complete/")
    initial_coins = profile.coins
    initial_xp = profile.total_xp

    request_post = factory.post(f'/api/v1/lesson/{first_lesson.id}/complete/', {}, format='json')
    response_post = complete_lesson(request_post, lesson_id=first_lesson.id)
    print("STATUS:", response_post.status_code)
    print("DATA:", response_post.data)

    assert response_post.status_code == 200, "POST completion failed!"
    post_data = response_post.data
    assert post_data['success'] is True
    assert post_data['gained_xp'] == first_lesson.xp_reward
    assert post_data['gained_coins'] == first_lesson.coins_reward
    assert 'user_stats' in post_data
    assert 'next_lesson_id' in post_data

    profile.refresh_from_db()
    assert profile.coins == initial_coins + first_lesson.coins_reward
    assert profile.total_xp == initial_xp + first_lesson.xp_reward
    print("[OK] POST endpoint contract and user stats update verified successfully.")

    # If there's a test lesson, verify incorrect/correct answer handling
    test_lesson = Lesson.objects.filter(type='test').first()
    if test_lesson:
        print(f"\n3. Testing POST /api/v1/lesson/{test_lesson.id}/complete/ with invalid answer")
        req_bad = factory.post(f'/api/v1/lesson/{test_lesson.id}/complete/', {'answer': 'wrong_answer_xyz'}, format='json')
        res_bad = complete_lesson(req_bad, lesson_id=test_lesson.id)
        print("STATUS:", res_bad.status_code, "DATA:", res_bad.data)
        assert res_bad.status_code == 400
        assert res_bad.data['success'] is False

        print(f"\n4. Testing POST /api/v1/lesson/{test_lesson.id}/complete/ with correct answer")
        req_good = factory.post(f'/api/v1/lesson/{test_lesson.id}/complete/', {'answer': test_lesson.correct_option}, format='json')
        res_good = complete_lesson(req_good, lesson_id=test_lesson.id)
        print("STATUS:", res_good.status_code, "DATA:", res_good.data)
        assert res_good.status_code == 200
        assert res_good.data['success'] is True
        print("[OK] Test lesson answer validation verified successfully.")

    print("\n=== ALL VERIFICATIONS PASSED SUCCESSFULLY ===")

if __name__ == '__main__':
    main()
