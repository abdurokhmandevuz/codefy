from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth import login, authenticate, logout, update_session_auth_hash
from django.contrib.auth.models import User
from django.contrib.auth.decorators import login_required
from django.http import JsonResponse
from django.contrib import messages
from django.views.decorators.csrf import csrf_exempt
from .models import UserProfile, GameLevel, UserGameScore, Course, Module, Lesson, Badge, CareerPath, LandingGoal, LandingFeature, TechTag, LandingReview, PracticeCard, LiveSession, LessonProgress
import json

def index(request):
    host = request.get_host()
    if host.startswith('api.'):
        return redirect('/api/docs/')
        
    goals = LandingGoal.objects.all().order_by('order')
    features = LandingFeature.objects.all().order_by('order')
    tech_tags = TechTag.objects.all().order_by('order')
    reviews = LandingReview.objects.all().order_by('order')
    paths = CareerPath.objects.all().order_by('order')
    
    context = {
        'goals': goals,
        'features': features,
        'tech_tags': tech_tags,
        'reviews': reviews,
        'paths': paths,
    }
    return render(request, 'app/index.html', context)

def register(request):
    if request.method == 'POST':
        u = request.POST.get('username')
        p = request.POST.get('password')
        pc = request.POST.get('confirm_password')
        if p != pc:
            return render(request, 'app/register.html', {'error': 'Parollar mos tushmadi'})
        if User.objects.filter(username=u).exists():
            return render(request, 'app/register.html', {'error': 'Bu nom band'})
        
        user = User.objects.create_user(username=u, password=p)
        login(request, user)
        # Create progress and set not completed
        UserProfile.objects.create(user=user, onboarding_complete=False)
        return redirect('onboarding')
        
    return render(request, 'app/register.html')

def login_view(request):
    if request.method == 'POST':
        u = request.POST.get('username')
        p = request.POST.get('password')
        user = authenticate(request, username=u, password=p)
        if user is not None:
            login(request, user)
            progress, _ = UserProfile.objects.get_or_create(user=user)
            if not progress.onboarding_complete:
                return redirect('onboarding')
            return redirect('dashboard')
        else:
            return render(request, 'app/login.html', {'error': 'Login yoki parol xato'})
            
    return render(request, 'app/login.html')

@login_required(login_url='register')
def onboarding(request):
    progress, _ = UserProfile.objects.get_or_create(user=request.user)
    if request.method == 'POST':
        progress.onboarding_complete = True
        progress.save()
        return JsonResponse({'success': True})
    
    if progress.onboarding_complete:
        return redirect('dashboard')
        
    return render(request, 'app/onboarding.html')

def logout_view(request):
    logout(request)
    return redirect('index')

@login_required(login_url='register')
def dashboard(request):
    progress, _ = UserProfile.objects.get_or_create(user=request.user)

    if not progress.selected_course:
        course = Course.objects.first()
        if course:
            progress.selected_course = course
            progress.save()

    course = progress.selected_course
    modules_data = []
    
    # Get all LessonProgress for the user
    user_lesson_progresses = LessonProgress.objects.filter(user=request.user)
    completed_ids = set(user_lesson_progresses.filter(status='completed').values_list('lesson_id', flat=True))
    
    found_next = False  # only the first uncompleted lesson gets is_next=True

    overall_completed = 0
    overall_total = 0

    if course:
        for module in course.modules.all().order_by('order'):
            lessons_qs = module.lessons.all().order_by('order')
            total = lessons_qs.count()
            overall_total += total
            
            done_count = sum(1 for l in lessons_qs if l.id in completed_ids)
            overall_completed += done_count
            pct = int((done_count / total * 100)) if total else 0

            lesson_items = []
            prev_done = True
            for lesson in lessons_qs:
                is_done = lesson.id in completed_ids
                is_next = False
                if not is_done and not found_next:
                    is_next = True
                    found_next = True
                    
                # Create or update LessonProgress
                lp, _ = LessonProgress.objects.get_or_create(user=request.user, lesson=lesson)
                if is_done:
                    lp.status = 'completed'
                    lp.progress_percent = 100
                elif is_next:
                    lp.status = 'in_progress'
                else:
                    lp.status = 'locked'
                lp.save()

                lesson_items.append({
                    'lesson': lesson,
                    'done': is_done,
                    'is_next': is_next,
                    'prev_done': prev_done,
                })
                prev_done = is_done

            modules_data.append({
                'module': module,
                'lessons': lesson_items,
                'pct': pct,
                'done': done_count,
                'total': total,
            })

    overall_percent = int((overall_completed / overall_total * 100)) if overall_total else 0

    context = {
        'progress': progress,
        'course': course,
        'modules_data': modules_data,
        'completed_total': overall_completed,
        'total_lessons': overall_total,
        'overall_percent': overall_percent,
    }
    return render(request, 'app/dashboard.html', context)


@login_required(login_url='register')
def lesson(request, lesson_id):
    from django.shortcuts import get_object_or_404
    lesson_obj = get_object_or_404(Lesson, id=lesson_id)
    progress, _ = UserProfile.objects.get_or_create(user=request.user)
    
    lp, _ = LessonProgress.objects.get_or_create(user=request.user, lesson=lesson_obj)
    
    context = {
        'lesson': lesson_obj,
        'progress': progress,
        'is_completed': lp.status == 'completed'
    }
    return render(request, 'app/lesson.html', context)

@csrf_exempt
@login_required
def lesson_complete(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        lesson_id = data.get('lesson_id')
        try:
            lesson_obj = Lesson.objects.get(id=lesson_id)
            progress = UserProfile.objects.get(user=request.user)
            
            lp, _ = LessonProgress.objects.get_or_create(user=request.user, lesson=lesson_obj)
            
            if lp.status != 'completed':
                lp.status = 'completed'
                lp.progress_percent = 100
                lp.save()
                
                # Also update old logic just in case
                if lesson_obj not in progress.completed_lessons.all():
                    progress.completed_lessons.add(lesson_obj)
                
                progress.total_xp += 10 # Add 10 XP for lesson
                progress.save()
                
            return JsonResponse({'success': True, 'xp': progress.total_xp})
        except Lesson.DoesNotExist:
            return JsonResponse({'success': False, 'error': 'Lesson not found'})
        except Exception as e:
            return JsonResponse({'success': False, 'error': str(e)})
    return JsonResponse({'success': False})

@login_required
def game_complete(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            level_id = data.get('level_id')
            level = GameLevel.objects.get(id=level_id)
            
            progress = UserProfile.objects.get(user=request.user)
            progress.total_xp += 50
            progress.unlocked_game_levels = max(progress.unlocked_game_levels, level.level_number + 1)
            
            # Badge 3: Bug Hunter
            b3, _ = Badge.objects.get_or_create(name="Bug Hunter", defaults={'description': "O'yin bosqichini vaqtida yechdingiz!", 'icon': 'bug'})
            if b3 not in progress.earned_badges.all():
                progress.earned_badges.add(b3)
                
            progress.save()
            
            return JsonResponse({'success': True})
        except Exception as e:
            return JsonResponse({'success': False, 'error': str(e)})
    return JsonResponse({'success': False})

@login_required
def leaderboard(request):
    top_users = UserProfile.objects.all().order_by('-total_xp')[:10]
    return render(request, 'app/leaderboard.html', {'top_users': top_users})

def check_and_award_badges(progress):
    new_badges = []
    # Badge 1: Birinchi Qadam
    if progress.completed_lessons.count() >= 1:
        b1, _ = Badge.objects.get_or_create(name="Birinchi Qadam", defaults={'description': "Ilk darsingizni muvaffaqiyatli tugatdingiz!", 'icon': 'footprints'})
        if b1 not in progress.earned_badges.all():
            progress.earned_badges.add(b1)
            new_badges.append(b1)
            
    # Badge 2: Pro Dasturchi
    if progress.is_pro:
        b2, _ = Badge.objects.get_or_create(name="Pro Dasturchi", defaults={'description': "Premium statusini oldingiz!", 'icon': 'crown'})
        if b2 not in progress.earned_badges.all():
            progress.earned_badges.add(b2)
            new_badges.append(b2)
            
    return new_badges

@login_required
def profile(request):
    progress = UserProfile.objects.get(user=request.user)
    # Check if they deserve any new badges right now
    check_and_award_badges(progress)
    
    context = {
        'progress': progress,
        'badges': progress.earned_badges.all()
    }
    return render(request, 'app/profile.html', context)

@login_required
def upgrade_pro(request):
    if request.method == 'POST':
        progress = UserProfile.objects.get(user=request.user)
        progress.is_pro = True
        progress.save()
        return JsonResponse({'success': True})
    return JsonResponse({'success': False})

@login_required
def ai_mentor(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        code = data.get('code', '')
        
        # Simple rule-based AI simulation
        hint = "Hammasi to'g'ri ko'rinmoqda, ishga tushirib ko'ring!"
        
        if 'print' not in code:
            hint = "E'tibor bering, ekranga nimadir chiqarish uchun doim `print()` funksiyasi kerak."
        elif 'print(' in code and ')' not in code:
            hint = "Siz `print` funksiyasining yopuvchi qavsini `)` yozishni unutdingiz shekilli."
        elif 'print' in code and '"' not in code and "'" not in code:
            hint = "Matnlarni doimo qo'shtirnoq ichiga yozish kerakligini yodda tuting."
        elif '==' in code and 'if' not in code:
            hint = "`==` belgisidan odatda shart (if) operatori bilan foydalaniladi."
        elif 'def ' in code and ':' not in code:
            hint = "Funksiya e'lon qilayotganda qator oxiriga ikki nuqta `:` qoyishni unutmang."
        
        return JsonResponse({'success': True, 'hint': hint})
    return JsonResponse({'success': False})

def premium(request):
    return render(request, 'app/premium.html')

def pricing(request):
    return render(request, 'app/pricing.html')

@login_required
def practice(request):
    cards = PracticeCard.objects.all().order_by('order')
    return render(request, 'app/practice.html', {'cards': cards})

from .models import Project, ProjectFile

@login_required
def build(request):
    project, created = Project.objects.get_or_create(user=request.user, name="Mening Loyiham")
    if created:
        ProjectFile.objects.create(project=project, name="index.html", content="<h1>Salom Dunyo!</h1>\n<p>Bu mening birinchi kodim.</p>", language="html")
        ProjectFile.objects.create(project=project, name="style.css", content="body {\n  background-color: #f4f4f9;\n  font-family: sans-serif;\n  text-align: center;\n  padding-top: 50px;\n}", language="css")
        ProjectFile.objects.create(project=project, name="script.js", content="console.log('Salom!');", language="javascript")
    
    files = project.files.all()
    return render(request, 'app/build.html', {'project': project, 'files': files})

@csrf_exempt
@login_required
def save_project_file(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            file_id = data.get('file_id')
            content = data.get('content', '')
            p_file = ProjectFile.objects.get(id=file_id, project__user=request.user)
            p_file.content = content
            p_file.save()
            return JsonResponse({'success': True})
        except Exception as e:
            return JsonResponse({'success': False, 'error': str(e)})
    return JsonResponse({'success': False})

@login_required
def library(request):
    paths = CareerPath.objects.all().order_by('order')
    return render(request, 'app/library.html', {'paths': paths})

@login_required
def events(request):
    import datetime
    now = datetime.datetime.now()
    upcoming_sessions = LiveSession.objects.filter(datetime__gte=now).order_by('datetime')
    past_sessions = LiveSession.objects.filter(datetime__lt=now).order_by('-datetime')
    return render(request, 'app/events.html', {
        'upcoming_sessions': upcoming_sessions,
        'past_sessions': past_sessions
    })

@login_required(login_url='register')
def game_select(request):
    # This will use game.html or a new game_select.html
    levels = GameLevel.objects.all().order_by('level_number')
    progress, _ = UserProfile.objects.get_or_create(user=request.user)
    return render(request, 'app/game.html', {'levels': levels, 'unlocked': progress.unlocked_game_levels})

@login_required(login_url='register')
def game_play(request, level_id):
    # Render the new game mechanic for a specific level
    level = GameLevel.objects.get(level_number=level_id)
    return render(request, 'app/game_play.html', {'level': level})

@login_required
def game_submit(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        # handle logic validation
        return JsonResponse({'success': True, 'stars': 3})
    return JsonResponse({'success': False})

@login_required
def courses(request):
    all_courses = Course.objects.all()
    progress, _ = UserProfile.objects.get_or_create(user=request.user)
    course_data = []
    for c in all_courses:
        total = Lesson.objects.filter(module__course=c).count()
        completed = progress.completed_lessons.filter(module__course=c).count()
        pct = int((completed / total * 100) if total > 0 else 0)
        course_data.append({'course': c, 'total': total, 'completed': completed, 'pct': pct})
    return render(request, 'app/courses.html', {'course_data': course_data})

@login_required
def settings_view(request):
    if request.method == 'POST':
        action = request.POST.get('action')
        if action == 'update_name':
            new_name = request.POST.get('username', '').strip()
            if new_name and new_name != request.user.username:
                if not User.objects.filter(username=new_name).exists():
                    request.user.username = new_name
                    request.user.save()
                    messages.success(request, 'Ism muvaffaqiyatli yangilandi!')
                else:
                    messages.error(request, 'Bu ism allaqachon band!')
        elif action == 'change_password':
            old_pw = request.POST.get('old_password')
            new_pw = request.POST.get('new_password')
            if request.user.check_password(old_pw):
                request.user.set_password(new_pw)
                request.user.save()
                update_session_auth_hash(request, request.user)
                messages.success(request, 'Parol muvaffaqiyatli yangilandi!')
            else:
                messages.error(request, 'Eski parol noto`g`ri!')
        return redirect('settings')
    return render(request, 'app/settings.html')

@login_required
def certificate(request, course_id):
    course = get_object_or_404(Course, id=course_id)
    progress, _ = UserProfile.objects.get_or_create(user=request.user)
    total = Lesson.objects.filter(module__course=course).count()
    completed = progress.completed_lessons.filter(module__course=course).count()
    if total == 0 or completed < total:
        return redirect('dashboard')
    return render(request, 'app/certificate.html', {
        'course': course,
        'user': request.user,
        'completed': completed,
    })

# --- Community Views ---
from .models import Discussion, Comment, Like, Report, BannedWord

@login_required(login_url='register')
def community_list(request):
    filter_type = request.GET.get('filter', 'all')
    discussions = Discussion.objects.all().order_by('-created_at')
    
    if filter_type == 'questions':
        discussions = discussions.filter(code_snippet='')
    elif filter_type == 'code':
        discussions = discussions.exclude(code_snippet='')
    elif filter_type == 'my_lessons':
        # Get lessons user is currently on
        user_lessons = LessonProgress.objects.filter(user=request.user, status='in_progress').values_list('lesson_id', flat=True)
        discussions = discussions.filter(lesson_id__in=user_lessons)
        
    return render(request, 'app/community.html', {
        'discussions': discussions,
        'filter_type': filter_type,
    })

def has_profanity(text):
    banned = BannedWord.objects.values_list('word', flat=True)
    text_lower = text.lower()
    for w in banned:
        if w in text_lower:
            return True
    return False

@login_required(login_url='register')
def community_new(request):
    if request.method == 'POST':
        title = request.POST.get('title', '')
        body = request.POST.get('body', '')
        code_snippet = request.POST.get('code_snippet', '')
        code_language = request.POST.get('code_language', '')
        lesson_id = request.POST.get('lesson_id')
        
        if has_profanity(title) or has_profanity(body) or has_profanity(code_snippet):
            messages.error(request, 'Xabaringizda nojo\'ya so\'zlar bor. Iltimos, tuzating.')
            return render(request, 'app/community_new.html', {
                'lessons': Lesson.objects.all(),
                'title': title, 'body': body, 'code_snippet': code_snippet
            })
            
        discussion = Discussion.objects.create(
            user=request.user,
            title=title,
            body=body,
            code_snippet=code_snippet,
            code_language=code_language,
            lesson_id=lesson_id if lesson_id else None
        )
        
        # XP Reward for asking question
        profile = request.user.userprofile
        profile.total_xp += 5
        profile.save()
        
        return redirect('community_detail', discussion_id=discussion.id)
        
    return render(request, 'app/community_new.html', {
        'lessons': Lesson.objects.all()
    })

@login_required(login_url='register')
def community_detail(request, discussion_id):
    discussion = get_object_or_404(Discussion, id=discussion_id)
    
    if request.method == 'POST':
        body = request.POST.get('body', '')
        if has_profanity(body):
            messages.error(request, 'Izohingizda nojo\'ya so\'zlar bor.')
        else:
            Comment.objects.create(
                discussion=discussion,
                user=request.user,
                body=body
            )
            # XP Reward for commenting
            profile = request.user.userprofile
            profile.total_xp += 2
            profile.save()
            return redirect('community_detail', discussion_id=discussion.id)
            
    comments = discussion.comments.all().order_by('created_at')
    
    # Check if user liked
    user_liked_discussion = Like.objects.filter(user=request.user, discussion=discussion).exists()
    
    return render(request, 'app/community_detail.html', {
        'discussion': discussion,
        'comments': comments,
        'user_liked_discussion': user_liked_discussion,
    })

@csrf_exempt
@login_required(login_url='register')
def community_like(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            item_type = data.get('type') # 'discussion' or 'comment'
            item_id = data.get('id')
            
            if item_type == 'discussion':
                item = Discussion.objects.get(id=item_id)
                like, created = Like.objects.get_or_create(user=request.user, discussion=item)
                if not created:
                    like.delete()
                    item.likes_count -= 1
                    item.save()
                    return JsonResponse({'status': 'unliked', 'likes': item.likes_count})
                else:
                    item.likes_count += 1
                    item.save()
                    return JsonResponse({'status': 'liked', 'likes': item.likes_count})
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=400)
    return JsonResponse({'error': 'Invalid request'}, status=400)

@csrf_exempt
@login_required(login_url='register')
def community_accept_answer(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            comment_id = data.get('comment_id')
            comment = Comment.objects.get(id=comment_id)
            
            # Only discussion author can accept
            if request.user != comment.discussion.user:
                return JsonResponse({'error': 'Unauthorized'}, status=403)
                
            if not comment.is_accepted_answer:
                # Unaccept others
                Comment.objects.filter(discussion=comment.discussion).update(is_accepted_answer=False)
                
                comment.is_accepted_answer = True
                comment.save()
                
                # Reward XP to comment author
                profile = comment.user.userprofile
                profile.total_xp += 15
                profile.save()
                
                return JsonResponse({'status': 'accepted'})
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=400)
    return JsonResponse({'error': 'Invalid request'}, status=400)
