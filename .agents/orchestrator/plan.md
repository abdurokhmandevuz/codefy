# Orchestration Plan — Codefy Learning System

## Overview
This plan outlines the full-stack implementation of the Codefy Learning System across Django Backend and Flutter Frontend.

## Milestones

### Milestone 1: Django Backend Models Expansion & Lesson Detail/Complete API
- **Scope**:
  - Expand models for Lesson types (Theory, Test, Code writing) in Django backend (`app`/`src`).
  - Implement `/api/v1/lesson/{id}` GET API to return test options (`options`), correct answers (`correct_option`), and XP/Coins awards.
  - Implement lesson completion POST/PUT endpoint (or `/api/v1/lesson/{id}/complete`) that validates answers, calculates/adds Coins & XP to User profile, updates Streak, unlocks the next lesson, and returns updated gamification state.
  - Unit/Integration tests for Django endpoints.

### Milestone 2: Flutter Frontend Lesson Types Rendering & Answer Validation
- **Scope**:
  - Update Flutter models & service calls to parse `/api/v1/lesson/{id}` API response.
  - Implement dynamic rendering for Lesson screens in `codefy_mobile` based on lesson type (`theory`, `test`, `code`).
  - Implement answer selection/validation logic for test & code types with immediate UI feedback (correct/incorrect state).
  - Implement "Tugatish" (Finish) button logic and lesson completion flow.

### Milestone 3: Gamification State Sync & Lesson Unlock
- **Scope**:
  - Handle backend API response upon lesson completion in Flutter frontend.
  - Update user state (Coins, XP, Streak) in state management (e.g. Provider/Riverpod/Bloc/GetX/StatefulNotifier) so TopBar and Home screen update immediately.
  - Unlock next lesson on the roadmap/map in Home screen upon return.
  - Ensure navigation auto-returns to Home screen on lesson finish.

### Milestone 4: Verification & E2E Acceptance Testing
- **Scope**:
  - Run `flutter analyze` across `codefy_mobile` to verify 0 errors on lesson screens.
  - Run Django backend test suite / verification script to ensure `/api/v1/lesson/{id}` JSON structure and gamification state updates match criteria.
  - Forensic Auditor integrity audit to verify authentic implementation.

## Execution Strategy
- Explorer subagent investigates codebase structure.
- Worker subagent implements Backend & API changes.
- Worker subagent implements Flutter Frontend changes & state sync.
- Reviewer & Challenger subagents review and verify code.
- Forensic Auditor performs integrity verification.
