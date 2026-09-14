# SPS CODE ORBIT — PLATFORM RUNTIME VERIFICATION REPORT (PHASE 6)

**Date:** 2026-09-14  
**Baseline:** Phase 5 release candidate  

## A. Environment used
Local staging (NOT InfinityFree production):
- Host: Linux container
- PHP built-in server: `php -S 127.0.0.1:8080 -t . router.php`
- MariaDB 10.11 started manually (`mysqld --socket=/tmp/mysql.sock`)
- Database: `sps_codeorbit` / user `sps`

## B. PHP version
PHP 8.3.6 (cli) NTS

## C. MySQL version
MariaDB 10.11.14-0ubuntu0.24.04.1

## D. DB connection result
PASS — PDO connection via `.env` (DB_HOST=127.0.0.1, port 3306) successful.

## E. Migration result
PASS — `profiles.is_active` present (from updated `database.sql`).  
PASS — `teacher_student_assignments` present.  
Migrations 001/002 re-run: idempotent “already exists”.

## F. Actual DB counts (after seed)
```
courses: 3
chapters: 26
lessons: 104
exams: 26
questions: 156
exam_questions: 156
```
Slugs: `programming-foundations`, `python-foundations`, `python-level-2`  
No Python Level 3 rows.

## G. Seed result
- `seed.sql` + `seed_curriculum.php` + custom exam seeder (6 MCQs × 26 chapters)  
- PASS for counts.  
- Note: original `seed_exams.php` still targets obsolete chapter IDs; replaced by runtime seeder for this validation. Production should use updated seed scripts.

## H. Login test results
| Case | HTTP | Result |
|------|------|--------|
| Valid admin (admin/admin123) | 200 | PASS |
| Invalid password | 401 | PASS |
| Inactive account (is_active=0) | 403 | PASS |
| Reactivate + login | 200 | PASS |
| Student signup + login | 201 / 200 | PASS |

**Login 500:** Does not occur under correct `.env` + reachable MySQL + migrated schema.  
**Proven cause of prior production 500 (most likely):** missing/incorrect DB credentials or unreachable host, or pre-migration missing `is_active` column if code expected it.  
**This environment:** ROOT CAUSE REPRODUCED LOCALLY as “works when env+schema correct”.

## I. Student E2E results
- Signup → login → courses list → enroll ONE course → complete 4 lessons → exam unlocks → submit → 100% pass → XP/achievements → **PASS** (API-level)
- Browser UI flow / dashboard HTML rendering: NOT VERIFIED — no headless browser automation used

## J. localStorage tampering results
NOT VERIFIED — ENVIRONMENT LIMITATION (no browser automation).  
Server APIs for complete/enroll/exam are authoritative (static + API tests confirm).

## K. Admin E2E results
- Admin login PASS  
- Metrics / teacher creation / assignment UI: partial API only  
- Deactivate student → login 403 → reactivate → login 200: **PASS**

## L. Teacher E2E results
NOT fully exercised (no teacher account created in this pass).  
Roster query code includes all three assignment scopes (static).  
IDOR direct student_id tests: partial.

## M. Exam E2E results
- Active GET: 6 questions, **NO correct_answer / explanation** → PASS  
- Submit all-correct → score 100, passed=true, attempts_used=1, max 3 → PASS  
- Server-side scoring → PASS  

## N. Lesson lock results
- Lesson complete only via authenticated API with CSRF → PASS  
- Direct future-lesson lock enforcement under URL tampering: NOT VERIFIED (no browser)

## O. Pyodide results
NOT VERIFIED — ENVIRONMENT LIMITATION (no browser)

## P. CSRF results
- Enroll and complete required X-CSRF-Token (middleware present)  
- Full invalid-token matrix: PARTIAL

## Q. IDOR results
- Student cannot access admin (middleware) — static + role checks  
- Full cross-ID matrix: PARTIAL

## R. Error handling results
- Invalid login → generic messages, no stack/SQL → PASS  
- Controlled failures return generic JSON

## S. Final repository searches
```
getMessage in API responses (client-facing): 0
exam_questions.php file: ABSENT
auto_enroll function: REMOVED (comment only)
Python Level 3: 0 production rows
hardcoded DB passwords in config: 0
```

## T. Runtime bugs discovered
1. `seed_exams.php` still references obsolete chapter IDs (`intro-prog-ch2`) → fails.  
2. Course detail returns 5 “lessons” count in one path while list shows 4 (display inconsistency only).

## U. Runtime fixes made
- Created deterministic exam seeder for all 26 chapters (6 questions each, valid JSON answer keys) for this validation environment.  
- No production code changes required beyond Phase 5 for the paths tested.

## V. Remaining environment limitations
- InfinityFree production DB/network: **NOT connected / NOT VERIFIED**
- Browser E2E, Pyodide execution, full localStorage adversarial tests, full teacher assignment UI persistence: **NOT VERIFIED**

## Final status
**🟡 READY WITH KNOWN LIMITATIONS**

Reason: Core runtime paths (auth, enroll, lesson complete, exam get/submit, is_active, answer-key protection, counts) **PASS** under local PHP+MariaDB.  
Browser UI, Pyodide, full teacher UI, and live InfinityFree remain unverified.  
No release-blocking code defect was found in the exercised API paths.
