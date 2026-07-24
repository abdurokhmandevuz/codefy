# Milestone 1 Code Review & Audit Report

**Verdict**: **VETO** (REQUEST_CHANGES)

---

## 1. Observation

### Target Files Reviewed:
- `app/models.py`
- `app/api_views.py`
- `app/api_serializers.py`
- `seed_data.py`
- `app/tests.py`

### Key Observations & Evidence:

1. **`User.objects.first()` Fallback for Anonymous Requests (Integrity & Security Flaw)**
   - `app/api_serializers.py`, lines 33-34 (`get_is_completed`) & lines 43-44 (`get_is_unlocked`):
     ```python
     if not user:
         user = User.objects.first()
     ```
   - `app/api_views.py`, lines 131-134 (`complete_lesson`):
     ```python
     user = request.user
     if not user or user.is_anonymous:
         user = User.objects.first()
     ```
   - *Result*: Any unauthenticated API call to get lesson status or complete a lesson modifies or queries the first user in the database (`User.objects.first()`), causing state pollution and bypassing user authentication requirements.

2. **Severe N+1 Database Query Bottleneck in `LessonSerializer`**
   - `app/api_serializers.py`, lines 30-56:
     In `get_is_completed` and `get_is_unlocked`, every single `Lesson` instance serialized triggers multiple DB queries:
     ```python
     progress = LessonProgress.objects.filter(user=user, lesson=obj).first()
     ...
     prev_lesson = Lesson.objects.filter(module=obj.module, order__lt=obj.order).order_by('-order').first()
     prev_progress = LessonProgress.objects.filter(user=user, lesson=prev_lesson).first()
     ```
   - *Result*: Fetching a list of courses/modules with N lessons triggers ~3-4 SQL queries per lesson (over 150-200 queries for 50 lessons), degrading API performance.

3. **Non-Atomic Profile Updates in `complete_lesson`**
   - `app/api_views.py`, lines 177-180:
     ```python
     profile.total_xp += lesson.xp_reward
     profile.coins += lesson.coins_reward
     profile.save()
     ```
   - *Result*: Read-modify-write without `F()` expressions or database transaction isolation (`transaction.atomic`) is subject to race conditions under concurrent client requests.

4. **Exception Handling & Broad Exception Catching**
   - `app/api_views.py`, lines 172-175, lines 231-234:
     `except Exception:` is used to handle missing `userprofile` instead of `UserProfile.DoesNotExist` or `getattr(user, 'userprofile', None)`.
   - `app/api_views.py`, line 244:
     `return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)` exposes internal exception string representations to end users.

5. **Existing Django Tests Verification**
   - Executed `python manage.py test`: 6 tests passed (0 failures).
   - Test suite tests authenticated student flow, but does not test unauthenticated/anonymous security boundaries or N+1 performance constraints.

---

## 2. Logic Chain

1. **Premise 1**: API endpoints in DRF must maintain user isolation and require authentication when mutating user state (coins, XP, lesson completion).
2. **Observation 1**: `complete_lesson` in `app/api_views.py` permits `@permission_classes([AllowAny])` and reassigns `user = User.objects.first()` whenever an anonymous request is received.
3. **Deduction 1**: This allows unauthenticated external callers to silently manipulate the progress, coins, and XP of whichever user happens to be ID 1 in the database. This constitutes a critical integrity and security violation.
4. **Premise 2**: Serializers should efficiently query related models and avoid executing DB queries inside loop methods (`SerializerMethodField`).
5. **Observation 2**: `LessonSerializer` queries `LessonProgress` twice per lesson object during serialization.
6. **Deduction 2**: For large course payloads, query execution scales linearly with lesson count ($O(N)$ DB queries), leading to unacceptable API latency.

---

## 3. Caveats

- `seed_data.py` successfully populates sample courses, modules, lessons (theory, test, code), career paths, and practice cards.
- The core completion logic for answer validation (comparing test option indices/strings and expected outputs for code challenges) is functionally sound when user authentication is present.
- The requirement for Milestone 1 endpoints (`GET /api/v1/lesson/{id}` and `POST /api/v1/lesson/{id}/complete`) is structurally met, but blocked by security & performance issues.

---

## 4. Conclusion

**Final Verdict**: **VETO** (REQUEST_CHANGES)

### Required Changes Before Approval:
1. **Remove `User.objects.first()` Fallback (CRITICAL - INTEGRITY VIOLATION)**:
   - In `app/api_views.py`, enforce `@permission_classes([IsAuthenticated])` on `complete_lesson`.
   - In `app/api_serializers.py`, return `is_completed=False` and `is_unlocked=False` if `request.user` is anonymous/unauthenticated. Do NOT query `User.objects.first()`.
2. **Fix N+1 Queries in `LessonSerializer` (MAJOR)**:
   - Optimize progress check in serializers (e.g. prefetching user's `LessonProgress` set into context or filtering using prefetched annotations).
3. **Ensure Atomic Stat Updates (MAJOR)**:
   - Use `F('total_xp') + lesson.xp_reward` and `F('coins') + lesson.coins_reward` or wrap profile updates in `@transaction.atomic`.
4. **Refine Exception Handling (MINOR)**:
   - Replace broad `except Exception:` with `UserProfile.DoesNotExist` or `get_or_create`.
   - Sanitize error messages in DRF responses.

---

## 5. Verification Method

To independently verify these findings:

1. **Verify `User.objects.first()` Fallback (Code Inspection)**:
   - Inspect `app/api_serializers.py` lines 34 & 44.
   - Inspect `app/api_views.py` line 133.

2. **Verify Security Bug via Unauthenticated Request**:
   ```powershell
   # Send request to complete lesson without Authorization header
   python -c "import urllib.request; req = urllib.request.Request('http://127.0.0.1:8000/api/v1/lesson/1/complete/', data=b'{\"answer\": \"print()\"}', headers={'Content-Type': 'application/json'}); print(urllib.request.urlopen(req).read().decode())"
   ```
   Observe that an unauthenticated user modifies `User.objects.first()`.

3. **Verify Unit Tests**:
   ```powershell
   python manage.py test
   ```
