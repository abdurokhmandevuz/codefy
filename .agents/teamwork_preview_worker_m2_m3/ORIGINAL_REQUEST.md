## 2026-07-24T06:06:37Z
You are Worker Agent teamwork_preview_worker_m2_m3.
Your working directory is: C:\Users\abdur\OneDrive\Desktop\codefy\.agents\teamwork_preview_worker_m2_m3
Project root is: C:\Users\abdur\OneDrive\Desktop\codefy

MANDATORY INTEGRITY WARNING:
DO NOT CHEAT. All implementations must be genuine. DO NOT hardcode test results, create dummy/facade implementations, or circumvent the intended task. A Forensic Auditor will independently verify your work. Integrity violations WILL be detected and your work WILL be rejected.

Your task is Milestone 2 & Milestone 3 Flutter Frontend Implementation & Gamification Sync:
1. Create directory `.agents/teamwork_preview_worker_m2_m3` and `progress.md`.
2. Update `codefy_mobile/lib/services/api_service.dart`:
   - Upgrade `completeLesson(int lessonId, {dynamic answer})` to send `{ 'answer': answer }` via `POST $baseUrl/lesson/$lessonId/complete/`.
   - Return parsed JSON response from API.
3. Update `codefy_mobile/lib/screens/lesson_screen.dart`:
   - Inspect `_lessonData['type']` (support `'theory'`, `'test'`, `'code'`).
   - For `'theory'`: render lesson content markdown/text + optional code box + "Tugatish" button.
   - For `'test'`: render question text + interactive selectable options list (`options`) + "Tekshirish" button.
   - For `'code'`: render instruction content + code editor TextField (monospace font) + "Kodni tekshirish" button.
   - Handle answer submission: call `ApiService.completeLesson(widget.lessonId, answer: userAnswer)`.
   - On incorrect answer (response null or `success == false`): call `ApiService.decreaseHeart()`, show error feedback / shake animation, update heart count.
   - On correct answer / finish: Navigate to `LessonCompleteScreen(gainedXp: ..., gainedCoins: ..., userStats: ..., nextLessonId: ...)` passing real dynamic stats from backend API response.
4. Update `codefy_mobile/lib/screens/lesson_complete_screen.dart`:
   - Accept `gainedXp`, `gainedCoins`, `userStats`, `nextLessonId`.
   - Display dynamic `gainedXp` and `gainedCoins` values on UI.
   - Upon tapping continuation button, return to `HomeScreen`.
5. Update `codefy_mobile/lib/screens/home_screen.dart`:
   - Update `_buildTopBar(BuildContext context)` to render stat badges for **Coins** (`profile['coins']`) and **XP** (`profile['total_xp']`) alongside Streak and Hearts.
   - Ensure returning from `LessonScreen` calls `_loadData()` so Coins, XP, Streak in TopBar and newly unlocked lessons on the map update immediately.
6. Also synchronize all modified Flutter files to `C:\Users\abdur\OneDrive\Desktop\codefy_mobile` if needed so both directories remain consistent.
7. Run `flutter analyze` inside `codefy_mobile` using `run_command` and ensure NO errors exist for modified files (`lesson_screen.dart`, `lesson_complete_screen.dart`, `home_screen.dart`, `api_service.dart`).
8. Create handoff report in `.agents/teamwork_preview_worker_m2_m3/handoff.md`. Send completion message to parent.
