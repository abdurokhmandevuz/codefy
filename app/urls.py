from django.urls import path
from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('register/', views.register, name='register'),
    path('login/', views.login_view, name='login'),
    path('logout/', views.logout_view, name='logout'),
    path('onboarding/', views.onboarding, name='onboarding'),
    path('dashboard/', views.dashboard, name='dashboard'),
    path('lesson/<int:lesson_id>/', views.lesson, name='lesson'),
    path('api/lesson/complete/', views.lesson_complete, name='lesson_complete'),
    path('leaderboard/', views.leaderboard, name='leaderboard'),
    path('profile/', views.profile, name='profile'),
    path('api/upgrade/', views.upgrade_pro, name='upgrade_pro'),
    path('api/ai-mentor/', views.ai_mentor, name='ai_mentor'),
    path('premium/', views.premium, name='premium'),
    path('pricing/', views.pricing, name='pricing'),
    path('courses/', views.courses, name='courses'),
    path('settings/', views.settings_view, name='settings'),
    path('certificate/<int:course_id>/', views.certificate, name='certificate'),
    
    path('practice/', views.practice, name='practice'),
    path('build/', views.build, name='build'),
    path('api/build/save/', views.save_project_file, name='save_project_file'),
    path('library/', views.library, name='library'),
    path('events/', views.events, name='events'),

    # Game paths
    path('game/', views.game_select, name='game_select'),
    path('game/play/<int:level_id>/', views.game_play, name='game_play'),
    path('api/game/complete/', views.game_complete, name='game_complete'),
    path('game/api/submit/', views.game_submit, name='game_submit'),

    # Community paths
    path('community/', views.community_list, name='community_list'),
    path('community/new/', views.community_new, name='community_new'),
    path('community/<int:discussion_id>/', views.community_detail, name='community_detail'),
    path('community/api/like/', views.community_like, name='community_like'),
    path('community/api/accept-answer/', views.community_accept_answer, name='community_accept_answer'),
]
