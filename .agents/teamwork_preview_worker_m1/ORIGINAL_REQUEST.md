## 2026-07-24T06:04:47Z
You are Worker Agent teamwork_preview_worker_m1.
Your working directory is: C:\Users\abdur\OneDrive\Desktop\codefy\.agents\teamwork_preview_worker_m1
Project root is: C:\Users\abdur\OneDrive\Desktop\codefy

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A Forensic Auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Your assigned task is Milestone 1: Django Backend Models Expansion & Lesson Detail/Complete API Implementation.

Steps to perform:
1. Create your working directory `.agents/teamwork_preview_worker_m1` and initialize `progress.md` inside it.
2. Edit `app/models.py`:
   - Expand `Lesson` model with:
     - `LESSON_TYPE_CHOICES = [('theory', 'Theory'), ('test', 'Test'), ('code', 'Code Editor')]`
     - `type = models.CharField(max_length=20, choices=LESSON_TYPE_CHOICES, default='theory')`
     - `options = models.JSONField(default=list, blank=True)`
     - `correct_option = models.CharField(max_length=255, blank=True)`
     - `xp_reward = models.IntegerField(default=10)`
     - `coins_reward = models.IntegerField(default=5)`
3. Create and apply migrations:
   - Run `python manage.py makemigrations app` and `python manage.py migrate` using `run_command` (or update `create_tables.py` if needed).
4. Update `app/api_serializers.py`:
   - Ensure `LessonSerializer` exposes `id`, `title`, `description`, `type`, `content`, `options`, `correct_option`, `initial_code`, `expected_output`, `xp_reward`, `coins_reward`, `order`, `is_premium`, `is_practice`, `is_completed`.
5. Update `app/api_views.py`:
   - Upgrade `get_lesson_detail`:
     - Retrieve lesson details and compute `is_unlocked` and `is_completed` for the requesting user (or default user if unauthenticated in dev).
     - Return complete payload with `type`, `options`, `correct_option`, `xp_reward`, `coins_reward`, `is_unlocked`, `is_completed`.
   - Upgrade `complete_lesson`:
     - Parse `answer` from request data.
     - Validate answer against `correct_option` (for test) or `expected_output` (for code). If incorrect, return status 400 with `{'success': False, 'message': 'Incorrect answer'}`.
     - If correct (or theory): update `LessonProgress` status to `'completed'`. Add `xp_reward` and `coins_reward` to user's `UserProfile`.
     - Find next lesson in order: set or create its `LessonProgress` status to `'in_progress'`.
     - Return JSON matching specification:
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
6. Update `seed_data.py`:
   - Populate lessons with diverse types (`theory`, `test`, `code`), realistic `options` (e.g. `["print()", "input()", "len()", "str()"]`), `correct_option`, `xp_reward`, and `coins_reward`.
   - Execute `seed_data.py`.
7. Verify endpoint execution:
   - Create a test script (or run test requests) to verify `GET /api/v1/lesson/1/` and `POST /api/v1/lesson/1/complete/`.
8. Document all changes and verification results in `.agents/teamwork_preview_worker_m1/handoff.md`.
9. Send completion message back to parent.
