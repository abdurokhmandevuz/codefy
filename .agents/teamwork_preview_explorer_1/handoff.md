# Comprehensive Investigation Report & Technical Handoff

**Agent**: `teamwork_preview_explorer_1`  
**Date**: 2026-07-24  
**Working Directory**: `C:\Users\abdur\OneDrive\Desktop\codefy\.agents\teamwork_preview_explorer_1`  
**Project Root**: `C:\Users\abdur\OneDrive\Desktop\codefy`  

---

## 1. Observation

Direct observations from codebase inspection of Django backend and Flutter frontend:

### Backend Components (`C:\Users\abdur\OneDrive\Desktop\codefy\app`)
1. **`app/models.py`**:
   - `Lesson` model (lines 26–41): Currently defines `module`, `title`, `description`, `content`, `initial_code`, `expected_output`, `order`, `is_premium`, `is_practice`, `is_supercharge`, `is_guided_project`. **Missing**: `type` (`lesson_type` choice field: `"theory"`, `"test"`, `"code"`), `options` (JSONField or array), `correct_option` (CharField/IntegerField), `xp_reward` (IntegerField, default 10), `coins_reward` (IntegerField, default 5).
   - `UserProfile` model (lines 50–73): Stores `total_xp`, `streak_days`, `coins`, `hearts`, `league`, `completed_lessons` (ManyToMany to `Lesson`).
   - `LessonProgress` model (lines 74–89): `user` (FK to User), `lesson` (FK to Lesson), `progress_percent` (default 0), `status` (`'locked'`, `'in_progress'`, `'completed'`).
   - `PracticeTask` model (lines 143–157): Contains `task_type` (`'theory'`, `'quiz'`, `'code'`), `options` (JSONField), `correct_option`, `initial_code`, `expected_output`, `xp_reward`.
2. **`app/api_views.py`**:
   - `get_lesson_detail(request, lesson_id)` (lines 115–127): Only returns `id`, `title`, `content`, `initial_code`, `expected_output`, `is_premium`. **Missing**: `type`, `options`, `correct_option`, `xp_reward`, `coins_reward`, `is_unlocked`, `is_completed`.
   - `complete_lesson(request, lesson_id)` (lines 129–156): Hardcodes `profile.total_xp += 10` and `profile.coins += 5`. Does **not** validate user answer (`request.data.get('answer')`). Returns `{'status': 'success', 'xp_earned': 10}`. **Missing**: Answer validation, response format matching `PROJECT.md` (`success`, `message`, `gained_xp`, `gained_coins`, `user_stats`, `next_lesson_id`), and auto-unlocking the next lesson in order (`LessonProgress.status = 'in_progress'`).
3. **`app/api_serializers.py`**:
   - `LessonSerializer` (lines 17–29): Includes `id`, `title`, `description`, `order`, `is_premium`, `is_practice`, `is_completed`. Missing `type`, `options`, `correct_option`, `xp_reward`, `coins_reward`, `is_unlocked`.
4. **`app/api_urls.py`**:
   - Routes `/api/v1/lesson/<id>/` -> `api_views.get_lesson_detail`
   - Routes `/api/v1/lesson/<id>/complete/` -> `api_views.complete_lesson`
5. **`seed_data.py`**:
   - Creates `Course`, `Module`, and 7 `Lesson` instances. Lessons have generic `content` ("...") and lack `type`, `options`, `correct_option`, `xp_reward`, `coins_reward`.

### Frontend Components (`C:\Users\abdur\OneDrive\Desktop\codefy\codefy_mobile`)
1. **`codefy_mobile/lib/services/api_service.dart`**:
   - `getLessonDetail(int lessonId)` (lines 93–100): Fetches `GET $baseUrl/lesson/$lessonId/`.
   - `completeLesson(int lessonId)` (lines 102–108): Sends empty `POST $baseUrl/lesson/$lessonId/complete/`. Does not accept an `answer` parameter or parse detailed `user_stats` / `gained_xp` / `next_lesson_id`.
2. **`codefy_mobile/lib/screens/home_screen.dart`**:
   - `_buildTopBar(BuildContext context)` (lines 92–175): Displays user avatar, `displayName`, `streak_days`, and `hearts`. **Missing**: `coins` and `xp` display in the TopBar.
   - `_buildDynamicSnakePath(BuildContext context)` (lines 236–301): Builds snake path of `LevelNode` items. Computes state (`LevelState.completed`, `LevelState.active`, `LevelState.locked`). Tapping an active/completed node opens `LessonScreen` and calls `_loadData()` on returning.
3. **`codefy_mobile/lib/screens/lesson_screen.dart`**:
   - `_LessonScreenState` (lines 16–171): Single view rendering basic text (`content`) and optional code display (`initial_code`).
   - Button logic `_next()` (lines 47–53): Immediately calls `Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LessonCompleteScreen()))`. Does **not** check answer, call `completeLesson()`, or pass lesson completion results to completion screen.
4. **`codefy_mobile/lib/screens/lesson_complete_screen.dart`**:
   - Lines 86 & 119: Hardcoded text `'15'` XP TOPLANDI and `'5'` DAQIQA. Does not accept dynamic parameters from API completion response.
5. **`codefy_mobile/lib/screens/practice_solve_screen.dart`**:
   - Pre-existing solution pattern for rendering `'theory'`, `'quiz'`, and `'code'` tasks with heart deduction, error shake animation (`_shakeScreen`), and heart refill dialog.

---

## 2. Logic Chain

1. **Requirement R1 (Backend Models & API Expansion)**:
   - *Observation*: `Lesson` model and `get_lesson_detail` API do not expose `type`, `options`, `correct_option`, `xp_reward`, `coins_reward`, `is_unlocked`, or `is_completed`. `complete_lesson` API does not accept or validate answers, does not return `user_stats` or `next_lesson_id`, and does not unlock subsequent lessons in `LessonProgress`.
   - *Deduction*: `Lesson` model in `app/models.py` must be expanded with `type` (choices: `theory`, `test`, `code`), `options` (JSONField), `correct_option` (CharField/IntegerField), `xp_reward`, `coins_reward`.
   - *Deduction*: `get_lesson_detail` in `app/api_views.py` must build a JSON object matching `PROJECT.md` specification including `type`, `options`, `correct_option`, rewards, `is_unlocked`, and `is_completed`.
   - *Deduction*: `complete_lesson` in `app/api_views.py` must read `request.data.get('answer')`, validate it against `correct_option` (for test) or `expected_output` (for code), update `UserProfile` (`coins`, `total_xp`, `streak_days`), set `LessonProgress` for the current lesson to `'completed'`, set/create `LessonProgress` for the next lesson (by `order`) to `'in_progress'`, and return the specified JSON payload containing `user_stats` and `next_lesson_id`.

2. **Requirement R2 (Flutter Lesson Rendering & Answer Validation)**:
   - *Observation*: `LessonScreen` (in `codefy_mobile/lib/screens/lesson_screen.dart`) ignores lesson `type` and routes straight to `LessonCompleteScreen` on button click without invoking the API. `LessonCompleteScreen` displays hardcoded numbers.
   - *Deduction*: `LessonScreen` must inspect `_lessonData['type']` (or default to `'theory'` if omitted) and render type-specific UI:
     - **Theory**: Markdown/HTML theory text, code snippet, and a "Tugatish" button that submits completion.
     - **Test**: Question text, radio/card selectable options from `options` array, and a "Tekshirish" (Check) button.
     - **Code**: Instructions, initial code editor/TextField, and a "Kodni tekshirish" (Check Code) button.
   - *Deduction*: When checking an answer, `LessonScreen` will call `ApiService.completeLesson(lessonId, answer)`. If answer validation fails (or backend returns `success: false`), subtract a heart (via `ApiService.decreaseHeart()`) and trigger error animation. If correct, navigate to `LessonCompleteScreen(gainedXp: ..., gainedCoins: ..., nextLessonId: ...)` passing real data.

3. **Requirement R3 (Gamification State Sync & Unlock)**:
   - *Observation*: TopBar in `home_screen.dart` currently displays `streak_days` and `hearts` but omits `coins` and `xp`. The lesson map re-loads user data on returning from `LessonScreen`.
   - *Deduction*: TopBar widget (`_buildTopBar`) in `home_screen.dart` should be updated to display stat badges for `Coins` (e.g. `Icons.monetization_on`) and `XP` (e.g. `Icons.star_rounded`), alongside `Streak` and `Hearts`.
   - *Deduction*: When `complete_lesson` unlocks the next lesson in `LessonProgress`, `_loadData()` in `HomeScreen` fetches updated course data and renders the newly unlocked lesson node as `LevelState.active`.

---

## 3. Caveats

1. **Multiple Flutter Directories**:
   - `C:\Users\abdur\OneDrive\Desktop\codefy_mobile` exists on the Desktop alongside project root `C:\Users\abdur\OneDrive\Desktop\codefy`. We synchronized/copied the updated Flutter files into `C:\Users\abdur\OneDrive\Desktop\codefy\codefy_mobile` so that the primary git workspace contains all required source files.
2. **Code Execution Engine vs String Comparison**:
   - For `type == "code"`, real code execution in Python/JS sandbox requires backend worker containers. In current mobile scope, string/regex matching against `expected_output` or output matching is standard.
3. **Database Migrations**:
   - Model changes in `app/models.py` require running `python manage.py makemigrations` and `python manage.py migrate` (or executing migration script `create_tables.py`).

---

## 4. Conclusion

The current system has foundational models and UI structure, but critical feature wiring for Requirements R1, R2, R3 is incomplete:
1. **Backend**: `Lesson` model needs 5 missing fields (`type`, `options`, `correct_option`, `xp_reward`, `coins_reward`). `get_lesson_detail` and `complete_lesson` API endpoints need to be upgraded to adhere strictly to the JSON contract in `PROJECT.md`.
2. **Frontend**: `ApiService` needs `completeLesson(int id, dynamic answer)`. `LessonScreen` needs 3 distinct rendering modes (`theory`, `test`, `code`), client-side/server-side answer validation, heart reduction on wrong answers, and parameter passing to `LessonCompleteScreen`.
3. **Gamification**: `TopBar` needs `Coins` and `XP` stat badges. Next lesson auto-unlocking in `LessonProgress` will dynamically unlock the next level node on `HomeScreen`.

---

## 5. Recommended Technical Strategy

### Phase 1: Django Backend Implementation (Requirement R1)
1. **Modify `app/models.py`**:
   Add fields to `Lesson`:
   ```python
   LESSON_TYPE_CHOICES = [
       ('theory', 'Theory'),
       ('test', 'Test'),
       ('code', 'Code Editor'),
   ]
   type = models.CharField(max_length=20, choices=LESSON_TYPE_CHOICES, default='theory')
   options = models.JSONField(default=list, blank=True) # list of string options e.g. ["print()", "input()", "len()", "str()"]
   correct_option = models.CharField(max_length=255, blank=True) # e.g. "0" or "print()"
   xp_reward = models.IntegerField(default=10)
   coins_reward = models.IntegerField(default=5)
   ```
2. **Update `app/api_serializers.py`**:
   Update `LessonSerializer` fields to include `['id', 'title', 'description', 'type', 'content', 'options', 'correct_option', 'initial_code', 'expected_output', 'xp_reward', 'coins_reward', 'order', 'is_premium', 'is_practice', 'is_completed']`.
3. **Update `app/api_views.py`**:
   - `get_lesson_detail`:
     Retrieve `Lesson` by `lesson_id`. Query `LessonProgress` for `request.user`. Check if previous lesson is completed or `order == 1` to compute `is_unlocked`. Return exact contract payload.
   - `complete_lesson`:
     Parse `answer = request.data.get('answer')`.
     If `lesson.type == 'test'`: compare `str(answer).strip()` with `str(lesson.correct_option).strip()`.
     If `lesson.type == 'code'`: compare `str(answer).strip()` with `str(lesson.expected_output).strip()`.
     If invalid: return `Response({'success': False, 'message': 'Incorrect answer'}, status=400)`.
     If valid:
     Mark `LessonProgress(user=user, lesson=lesson, status='completed')`.
     Grant `xp_reward` and `coins_reward` to `UserProfile`.
     Find next lesson: `next_lesson = Lesson.objects.filter(module=lesson.module, order__gt=lesson.order).order_by('order').first()`.
     If `next_lesson`: create/update `LessonProgress(user=user, lesson=next_lesson, status='in_progress')`.
     Return response payload:
     ```json
     {
       "success": true,
       "message": "Lesson completed successfully",
       "gained_xp": lesson.xp_reward,
       "gained_coins": lesson.coins_reward,
       "user_stats": {
         "coins": profile.coins,
         "xp": profile.total_xp,
         "streak": profile.streak_days
       },
       "next_lesson_id": next_lesson.id if next_lesson else None
     }
     ```
4. **Update `seed_data.py`**:
   Re-seed lessons with distinct types (`theory`, `test`, `code`), options, correct options, and rewards.

### Phase 2: Flutter Lesson Rendering & Validation (Requirement R2)
1. **Update `codefy_mobile/lib/services/api_service.dart`**:
   ```dart
   Future<Map<String, dynamic>?> completeLesson(int lessonId, {dynamic answer}) async {
     final response = await http.post(
       Uri.parse('$baseUrl/lesson/$lessonId/complete/'),
       headers: await _getAuthHeaders(),
       body: jsonEncode({'answer': answer}),
     );
     if (response.statusCode == 200) {
       return jsonDecode(response.body);
     }
     return null;
   }
   ```
2. **Enhance `codefy_mobile/lib/screens/lesson_screen.dart`**:
   - Add state variables: `_selectedOption`, `_codeController`, `_isChecking`, `_isError`, `_errorMessage`.
   - Render UI according to `_lessonData['type']`:
     - `theory`: Markdown/text view + code box.
     - `test`: Theory text + `ListView` of option cards with tap selection.
     - `code`: Instructions + `TextField` (monospace font, `JetBrains Mono`) for code entry.
   - Implement `_submitAnswer()`:
     - Calls `ApiService.completeLesson(widget.lessonId, answer: userAnswer)`.
     - On failure: call `ApiService.decreaseHeart()`, trigger shake animation, update heart count, show snackbar or dialog if hearts run out.
     - On success: Navigate to `LessonCompleteScreen` passing `gainedXp`, `gainedCoins`, `userStats`, `nextLessonId`.
3. **Update `codefy_mobile/lib/screens/lesson_complete_screen.dart`**:
   - Accept constructor properties: `final int gainedXp`, `final int gainedCoins`, `final Map<String, dynamic>? userStats`.
   - Display `gainedXp` and `gainedCoins` dynamically in the stats container.

### Phase 3: Gamification State Sync & Unlock (Requirement R3)
1. **Update TopBar in `codefy_mobile/lib/screens/home_screen.dart`**:
   Add stat badges for `Coins` and `XP`:
   ```dart
   Row(
     children: [
       _buildStatBadge(Icons.local_fire_department_rounded, '${profile['streak_days'] ?? 0}', Colors.orange),
       const SizedBox(width: 6),
       _buildStatBadge(Icons.star_rounded, '${profile['total_xp'] ?? 0}', Colors.amber),
       const SizedBox(width: 6),
       _buildStatBadge(Icons.monetization_on_rounded, '${profile['coins'] ?? 0}', Colors.yellow.shade700),
       const SizedBox(width: 6),
       _buildStatBadge(Icons.favorite, '${profile['hearts'] ?? 5}', const Color(0xFFFF4B4B)),
     ],
   )
   ```
2. **Lesson Map Unlocking Verification**:
   When `LessonCompleteScreen` pops or user returns to `HomeScreen`, `_loadData()` runs, fetching fresh course data with newly unlocked lessons (`is_completed: true` for completed, next lesson available for interaction).

---

## 6. Verification Method

1. **Backend Verification**:
   - Run `python manage.py makemigrations` and `python manage.py migrate`.
   - Run `python seed_data.py`.
   - Test endpoints using python script or curl:
     - `GET http://127.0.0.1:8000/api/v1/lesson/1/` -> inspect JSON for `type`, `options`, `correct_option`, `xp_reward`, `coins_reward`.
     - `POST http://127.0.0.1:8000/api/v1/lesson/1/complete/` with body `{"answer": ...}` -> inspect JSON for `success: true`, `gained_xp`, `gained_coins`, `user_stats`, `next_lesson_id`.
2. **Frontend Verification**:
   - Run `flutter analyze` inside `codefy_mobile` directory to ensure 0 errors.
   - Launch app or inspect widget state tree: test navigating to theory, test, and code lessons.
   - Verify wrong answer decreases heart and triggers shake.
   - Verify correct answer opens `LessonCompleteScreen` with dynamic rewards and returns to `HomeScreen` with updated TopBar (Coins, XP, Streak, Hearts) and unlocked next level node.

---
