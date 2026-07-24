# Project: Codefy Learning System

## Architecture
- Backend: Django REST framework (`app`/`src`)
- Frontend: Flutter mobile application (`codefy_mobile`)
- Data Flow:
  - Flutter app fetches `/api/v1/lesson/{id}` to load lesson content (theory, test, code).
  - User answers question / completes task.
  - Flutter app posts completion to backend API.
  - Backend updates user profile (Coins, XP, Streak) and lesson progress (unlocks next lesson).
  - Backend returns updated user stats & lesson status.
  - Flutter app updates state management (TopBar / Home UI) immediately and returns to Home.

## Code Layout
- Backend: `C:\Users\abdur\OneDrive\Desktop\codefy\app`
- Frontend: `C:\Users\abdur\OneDrive\Desktop\codefy\codefy_mobile`

## Milestones
| # | Name | Scope | Dependencies | Status |
|---|------|-------|-------------|--------|
| 1 | Django Backend Models & API | Lesson models expansion, `/api/v1/lesson/{id}` detail & completion endpoints | None | DONE |
| 2 | Flutter Lesson Rendering & Validation | Theory, test, code lesson UI rendering & answer validation | M1 | DONE |
| 3 | Gamification State Sync & Unlock | Coins/XP/Streak sync to TopBar/Home, next lesson unlock | M1, M2 | DONE |
| 4 | Verification & Audit | `flutter analyze`, API automated test script, Forensic Audit | M1, M2, M3 | DONE |

## Interface Contracts
### Django ↔ Flutter API
- `GET /api/v1/lesson/{id}`
  - Response:
    ```json
    {
      "id": 1,
      "title": "Lesson Title",
      "type": "test", // "theory" | "test" | "code"
      "content": "Lesson theory or instruction",
      "options": ["Option A", "Option B", "Option C", "Option D"],
      "correct_option": "0", // index or option text
      "xp_reward": 10,
      "coins_reward": 5,
      "is_unlocked": true,
      "is_completed": false
    }
    ```
- `POST /api/v1/lesson/{id}/complete/`
  - Body: `{"answer": ...}`
  - Response:
    ```json
    {
      "success": true,
      "message": "Lesson completed successfully",
      "gained_xp": 10,
      "gained_coins": 5,
      "user_stats": {
        "coins": 150,
        "xp": 320,
        "streak": 5
      },
      "next_lesson_id": 2
    }
    ```
