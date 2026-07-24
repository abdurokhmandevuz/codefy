from django.test import TestCase
from django.contrib.auth.models import User
from rest_framework.test import APIClient
from rest_framework import status
from app.models import Course, Module, Lesson, UserProfile, LessonProgress

class LessonAPITestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = User.objects.create_user(username='teststudent', password='password123')
        self.profile = UserProfile.objects.create(user=self.user, total_xp=50, coins=100, streak_days=2)
        self.client.force_authenticate(user=self.user)

        self.course = Course.objects.create(title='Test Course', track_type='python')
        self.module = Module.objects.create(course=self.course, title='Module 1', order=1)

        self.lesson_theory = Lesson.objects.create(
            module=self.module,
            title='Theory Lesson',
            type='theory',
            content='HTML content here',
            xp_reward=10,
            coins_reward=5,
            order=1
        )
        self.lesson_test = Lesson.objects.create(
            module=self.module,
            title='Test Lesson',
            type='test',
            content='Select answer',
            options=['print()', 'input()', 'len()'],
            correct_option='print()',
            xp_reward=15,
            coins_reward=10,
            order=2
        )
        self.lesson_code = Lesson.objects.create(
            module=self.module,
            title='Code Lesson',
            type='code',
            content='Write code outputting Hello',
            initial_code='print("Hello")',
            expected_output='Hello',
            xp_reward=20,
            coins_reward=15,
            order=3
        )

    def test_get_lesson_detail(self):
        response = self.client.get(f'/api/v1/lesson/{self.lesson_test.id}/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        data = response.json()
        self.assertEqual(data['id'], self.lesson_test.id)
        self.assertEqual(data['title'], 'Test Lesson')
        self.assertEqual(data['type'], 'test')
        self.assertEqual(data['options'], ['print()', 'input()', 'len()'])
        self.assertEqual(data['correct_option'], 'print()')
        self.assertEqual(data['xp_reward'], 15)
        self.assertEqual(data['coins_reward'], 10)
        self.assertIn('is_unlocked', data)
        self.assertIn('is_completed', data)

    def test_complete_theory_lesson_unlocks_next(self):
        response = self.client.post(f'/api/v1/lesson/{self.lesson_theory.id}/complete/', {})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        data = response.json()
        self.assertTrue(data['success'])
        self.assertEqual(data['gained_xp'], 10)
        self.assertEqual(data['gained_coins'], 5)
        self.assertEqual(data['user_stats']['coins'], 105)
        self.assertEqual(data['user_stats']['xp'], 60)
        self.assertEqual(data['next_lesson_id'], self.lesson_test.id)

        # Check LessonProgress status
        progress_theory = LessonProgress.objects.get(user=self.user, lesson=self.lesson_theory)
        self.assertEqual(progress_theory.status, 'completed')

        progress_test = LessonProgress.objects.get(user=self.user, lesson=self.lesson_test)
        self.assertEqual(progress_test.status, 'in_progress')

    def test_complete_test_lesson_incorrect_answer(self):
        response = self.client.post(f'/api/v1/lesson/{self.lesson_test.id}/complete/', {'answer': 'input()'}, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        data = response.json()
        self.assertFalse(data['success'])
        self.assertEqual(data['message'], 'Incorrect answer')

    def test_complete_test_lesson_correct_answer(self):
        response = self.client.post(f'/api/v1/lesson/{self.lesson_test.id}/complete/', {'answer': 'print()'}, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        data = response.json()
        self.assertTrue(data['success'])
        self.assertEqual(data['gained_xp'], 15)

    def test_complete_code_lesson_incorrect_answer(self):
        response = self.client.post(f'/api/v1/lesson/{self.lesson_code.id}/complete/', {'answer': 'World'}, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        data = response.json()
        self.assertFalse(data['success'])

    def test_complete_code_lesson_correct_answer(self):
        response = self.client.post(f'/api/v1/lesson/{self.lesson_code.id}/complete/', {'answer': 'Hello'}, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        data = response.json()
        self.assertTrue(data['success'])
        self.assertEqual(data['gained_xp'], 20)

    def test_unauthenticated_serializer_defaults(self):
        from app.api_serializers import LessonSerializer
        serializer_lesson1 = LessonSerializer(self.lesson_theory, context={})
        data1 = serializer_lesson1.data
        self.assertFalse(data1['is_completed'])
        self.assertTrue(data1['is_unlocked'])

        serializer_lesson2 = LessonSerializer(self.lesson_test, context={})
        data2 = serializer_lesson2.data
        self.assertFalse(data2['is_completed'])
        self.assertFalse(data2['is_unlocked'])

    def test_serializer_progress_map_context(self):
        from app.api_serializers import LessonSerializer
        progress_map = {
            self.lesson_theory.id: 'completed',
            self.lesson_test.id: 'in_progress'
        }
        serializer1 = LessonSerializer(self.lesson_theory, context={'progress_map': progress_map})
        self.assertTrue(serializer1.data['is_completed'])
        self.assertTrue(serializer1.data['is_unlocked'])

        serializer2 = LessonSerializer(self.lesson_test, context={'progress_map': progress_map})
        self.assertFalse(serializer2.data['is_completed'])
        self.assertTrue(serializer2.data['is_unlocked'])

