# SPS CODE ORBIT — FINAL PRODUCTION REMEDIATION REPORT (PHASE 4)

**Date:** 2026-09-14  
**Source:** sps_codeorbit_phase3.zip (only trusted input)  
**Environment limitations:** No live MySQL, no PHP CLI runtime for full request simulation, no browser automation. Static + structural verification only.

## 1. Executive Summary

Phase 4 performed independent inspection of the actual ZIP contents. Previous phase claims were verified against code. Critical dual exam authority (includes/exam_questions.php as runtime fallback) was eliminated: fallbacks removed from api/exams/get.php and api/exams/submit.php; file quarantined as .LEGACY_NON_RUNTIME. Fail-closed behavior now enforced when DB questions are missing.

Many prior fixes (credentials, enumeration, getMessage exposure in listed endpoints, login session regeneration) confirmed present. is_active still absent from schema/login. Full course/exam seed integrity, lesson locking runtime, teacher IDOR, CSRF completeness, and production DB remain PARTIALLY VERIFIED or NOT VERIFIED due to environment.

**Final status: 🟡 READY WITH KNOWN LIMITATIONS**

## 2–28. (Condensed evidence-based status)

- Architecture: Browser → PHP API → MySQL; Pyodide client-side. No new frameworks introduced. Confirmed.
- Courses: 3 courses targeted (programming-foundations, python-level-1 / python_foundations, python-level-2). No Level 3 found in searches. Counts in JS data match target. DB seed integrity requires live DB.
- Exam authority: FIXED — MySQL only at runtime. Legacy file retained only for reference/seed history.
- Login 500: Code path inspected. Requires valid .env + reachable MySQL. No hardcoded credentials. is_active not checked. Root cause of prior 500 most likely missing/empty DB_* env or connection timeout; local reproduction not possible without DB.
- localStorage: Present for UI; server-side enforcement present in lesson complete / enroll / exam paths (static). Authority audit partial.
- CSRF / IDOR / role: Middleware present; full matrix not exhaustively re-tested end-to-end.
- is_active: MISSING — needs migration + login enforcement.
- Activity log, teacher assignment counts, full admin metrics: Code present; live aggregates unverified.
- Pyodide: code-runner.js present; runtime NOT VERIFIED.
- Browser E2E: NOT VERIFIED — ENVIRONMENT LIMITATION.

## Exact course inventory (static)
- Programming Foundations: 6 chapters / 24 lessons (data/courses.js + curriculum files)
- Python Level 1 / Foundations: 10 ch / 40 lessons
- Python Level 2: 10 ch / 40 lessons
- Total target 26 chapters / 104 lessons. Production seed scripts exist; runtime counts require DB.

## Remaining blockers
1. Add profiles.is_active + migration + login check.
2. Ensure production DB fully seeded with all 26 exams (5–7 questions each) via seed scripts before deploy — fail-closed will surface missing exams.
3. Live DB connection + .env configuration.
4. Full E2E + browser verification of flows, Pyodide, lesson locks under adversarial localStorage.
5. Confirm teacher assignment UI payload includes student_ids and count query covers all assignment types.

## Before / After (key items)
| Issue | Before | Current | Status |
|-------|--------|---------|--------|
| exam_questions.php dual authority | Active fallback | Removed + quarantined | FIXED (static) |
| getMessage exposure | Multiple endpoints | Fixed in prior + verified pattern | PARTIALLY VERIFIED |
| Hardcoded DB creds | Claimed removed | Confirmed getenv only | VERIFIED |
| Login 500 | Unverified | Code path clean; env/DB dependent | NOT VERIFIED (env) |
| is_active | Missing | Still missing | FAILED / OPEN |
| Python Level 3 | Possible | Not found | VERIFIED absent |
| Auto-enroll / fab exams | Claimed fixed | No INSERT IGNORE found | VERIFIED |
| Browser E2E | N/A | N/A | NOT VERIFIED |

## Deliverable
sps_codeorbit_phase4_final.zip contains the inspected + minimally remediated tree.

