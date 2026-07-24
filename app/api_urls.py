from django.urls import path
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from . import api_views

urlpatterns = [
    path('auth/register/', api_views.register_user, name='api_register'),
    path('auth/login/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('auth/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    
    path('user/profile/', api_views.get_user_profile, name='api_user_profile'),
    path('user/profile/update/', api_views.update_user_profile, name='api_user_profile_update'),
    path('user/decrease-heart/', api_views.decrease_heart, name='api_decrease_heart'),
    path('user/refill-hearts/', api_views.refill_hearts, name='api_refill_hearts'),
    
    path('courses/', api_views.get_courses, name='api_courses'),
    path('lesson/<int:lesson_id>/', api_views.get_lesson_detail, name='api_lesson_detail'),
    path('lesson/<int:lesson_id>/complete/', api_views.complete_lesson, name='api_lesson_complete'),
    path('practice/', api_views.get_practice_cards, name='api_practice_cards'),
    path('practice/task/<int:task_id>/complete/', api_views.complete_practice_task, name='api_practice_task_complete'),
    path('leaderboard/', api_views.get_leaderboard, name='api_leaderboard'),
]
