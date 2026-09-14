# SPS CODE ORBIT — DATABASE AUTHORITY FIX REPORT

**Date:** 2026-09-14  
**Scope:** Login, Signup, Admin data source — single MySQL authority

## 1. Exact root cause of login failure (production)

**Most likely causes when only admin exists and login/signup "error":**

1. **`.env` misconfiguration on InfinityFree**  
   - Missing or wrong `DB_HOST` / `DB_NAME` / `DB_USER` / `DB_PASSWORD`  
   - Empty defaults → PDO fails → generic "Database connection error" / HTTP 500  
2. **Wrong database** (owner deleted an older DB that the app or panel still pointed at)  
3. **Schema incomplete** on the intended DB (e.g. missing `is_active` before migration) → query failure  
4. **Only admin row present** is **data state**, not a code bug: after a DB delete/recreate, only seed admin remains until signup creates new students.

**This environment (clean local MariaDB):** Login with correct `.env` → **HTTP 200**.  
Invalid password → **401**. Inactive → **403**.

## 2. Exact root cause of signup failure

Same class of issues as login: connection failure or schema mismatch.  
When DB is correct: Signup → **HTTP 201**, row appears in `profiles` of **the same** database, then login succeeds.

**Proven here:**
```
Signup newstudent2 → HTTP 201
SELECT username, role FROM profiles → admin + newstudent2
Login newstudent2 → HTTP 200
```

## 3–5. Database authority map

| Layer | Value |
|-------|--------|
| Config | `.env` → `config/config.php` → defines `DB_*` |
| Connection | **Only** `config/database.php` → `get_db_connection()` |
| All APIs | Call `get_db_connection()` exclusively (no alternate PDO/mysqli) |

**Configured (local test):**
- DB_HOST: 127.0.0.1  
- DB_NAME: sps_codeorbit  
- DB_USER: sps  

**Live `SELECT DATABASE()`:** `sps_codeorbit`  

**No** hardcoded InfinityFree hostnames, **no** `sql200`/`sql301`, **no** `db_store.json`, **no** second database.

## 6. Files changed

| File | Change |
|------|--------|
| `config/database.php` | Early validation if DB_* empty; clearer error_log; optional `DB_SOCKET`; single static PDO |
| `.env.example` | Clear InfinityFree + local instructions; no fake passwords |
| `api/admin/db_health.php` | **New** admin-only safe diagnostic (host, name, counts, no secrets) |

## 7. Old DB references removed

- No runtime `db_store` files present  
- No alternate PDO connections in API tree  
- Historical mentions remain only in old reports / inventory docs (documentation only)

## 8. Admin data source (every major metric)

| Metric | SQL source |
|--------|------------|
| total_students | `COUNT(*) FROM profiles WHERE role='student'` |
| total_teachers | `COUNT(*) FROM profiles WHERE role='teacher'` |
| total_courses | `COUNT(*) FROM courses` |
| total_lessons | `COUNT(*) FROM lessons` |
| total_exams | `COUNT(*) FROM exams` |
| completions | `lesson_progress` / `exam_attempts` |

**Proven:** After 1 student signup, metrics returned `total_students=1` matching MySQL.

## 9. Schema verification

- `profiles.is_active` present  
- `teacher_student_assignments` present  
- Canonical schema + migrations aligned  

## 10–17. Fresh DB test results

| Step | Result |
|------|--------|
| database.sql + seed + curriculum + exams | **PASS** (3/26/104/26/156) |
| Admin exists | **PASS** (1 profile) |
| Admin login | **PASS** HTTP 200 |
| Student signup | **PASS** HTTP 201; row in same DB |
| Student login | **PASS** HTTP 200 |
| Admin metrics students=1 | **PASS** |
| Enroll 1 course | **PASS**; `course_enrollments` count=1 |
| Complete lesson | **PASS**; `lesson_progress` count=1 |
| db_health SELECT DATABASE() | **PASS** = sps_codeorbit |

## 18. localStorage

Not authoritative for enroll/complete/exam/XP/role. Server APIs write MySQL only.

## 19. Security

- No password in responses  
- db_health admin-only, no secrets  
- Generic client errors; details in error_log  

## 20. Remaining limitations

- **InfinityFree live:** NOT VERIFIED (no production credentials in this environment)  
- Owner must set `.env` to the **current** panel DB (the one where they see only admin)  
- Signup will then create students **in that same DB**  
- Old deleted DB cannot and should not be restored by code  

## Owner action (critical)

1. Open InfinityFree MySQL panel → note **exact** Host, Database name, Username  
2. Put those into `.env` on the server (do not use local test values)  
3. Confirm schema is applied (`database.sql` + migrations)  
4. Confirm curriculum + exams seeded  
5. Login as admin → open `/api/admin/db_health.php` (while logged in as admin)  
6. Confirm `SELECT_DATABASE` matches the intended DB and counts match phpMyAdmin  
7. Signup a new student → confirm row appears in **that** `profiles` table  
8. Admin dashboard student count must increase by 1  

If login still fails after correct `.env`, check PHP error log for:  
`SPS DB connection failed: ... | host=... db=... user=...`

## Final status
**🟡 READY WITH KNOWN LIMITATIONS**

Code authority is single MySQL via `.env` + `get_db_connection()`.  
Login, signup, admin metrics, enroll, lesson complete all proven against the **same** database locally.  
InfinityFree deployment correctness depends on owner configuring `.env` to the live panel database.
