# SPS Code Orbit — Complete Project File Inventory

## 1. Project Summary

- **Project Purpose**: SPS Code Orbit is an interactive STEM and computer science learning platform for K-12 and preparatory students, teachers, and school administrators. It provides gamified curriculum pathways, coding lessons, interactive practice challenges, chapter exams, XP rewards, and comprehensive progress tracking.
- **Current Architecture**: Dual-Backend Hybrid. The live Cloud Run container runs a Node.js server (`server.js`) on port 3000, serving static HTML/JS/CSS frontend assets and intercepting `/api/*.php` API endpoint requests to read and write JSON storage files (`data/db_store.js` / `data/db_store.json`). Concurrently, a full PHP 8.x + MySQL backend architecture (65 PHP endpoints and 29 database tables in `database/database.sql`) exists as the foundational database-backed backend codebase.
- **Frontend Technology**: Vanilla HTML5, CSS3 (Tailwind CSS v4 & custom theme CSS), JavaScript (ES6+ async/await), custom web components (`js/components.js`), Lucide icons, and interactive canvas/code runner wrappers. A Next.js 15 App Router scaffold (`app/layout.tsx`, `next.config.ts`, `postcss.config.mjs`) is also present in the repository.
- **Backend Technology**: Active Container Runtime: Node.js HTTP/Express web server (`server.js`). Source Backend Architecture: PHP 8.x scripts in `/api/` with PDO MySQL database integration.
- **Database Technology**: Primary Source Architecture: MySQL relational database (29 tables defined in `database/database.sql`). Active Runtime Persistence: JSON file storage (`data/db_store.json` managed by `data/db_store.js`).
- **Authentication Architecture**: Session-based cookie authentication (`orbit_session`, `orbit_user_id`, `PHPSESSID`) supported by header fallback (`X-User-Id`, `Authorization: Bearer <token>`). Emulated in Node.js runtime (`server.js`) and implemented natively in PHP (`api/auth/*.php`, `middleware/auth.php`).
- **Session Architecture**: Managed on the frontend via `js/session.js` (`window.session`), executing `credentials: "same-origin"` API calls to `/api/auth/me.php`, `/api/auth/login.php`, and `/api/auth/logout.php`.
- **API Architecture**: RESTful JSON HTTP endpoints structured under `/api/*` (`/api/auth/`, `/api/courses/`, `/api/chapters/`, `/api/lessons/`, `/api/exams/`, `/api/student/`, `/api/teacher/`, `/api/admin/`, `/api/gamification/`, `/api/projects/`).
- **Curriculum/Content Architecture**: Multi-source architecture. Course and lesson content exist across JavaScript objects (`data/*_curriculum.js`, `data/curriculum_index.js`), JSON export payloads (`data/curriculum_export.json`), static HTML blocks (`student/lesson.html`), and MySQL tables (`courses`, `chapters`, `lessons`, `lesson_blocks`).
- **Progress Architecture**: Tracks course enrollment, completed lessons, chapter unlocks, and progress percentages stored in `data/db_store.json` at runtime and in MySQL tables (`lesson_progress`, `chapter_progress`, `course_progress`) in the PHP backend.
- **Exam Architecture**: Chapter-end multiple choice assessments defined in `data/chapter_exams.js` / `data/chapter_exams.json` and MySQL tables (`exams`, `questions`, `exam_attempts`). Automated scoring (>= 70% passing threshold) unlocks subsequent chapters.
- **Gamification Architecture**: XP points, daily login streaks, level progression, and badge achievements handled by `js/gamification.js`, `api/gamification/status.php`, `data/db_store.js`, and MySQL tables (`student_gamification`, `xp_events`, `achievements`, `student_achievements`).
- **Major Application Areas**:
  1. Public & Auth Pages (`index.html`, `login.html`, `signup.html`, `about.html`, `challenges.html`, `courses.html`)
  2. Student Portal (`student/dashboard.html`, `student/courses.html`, `student/course.html`, `student/chapter.html`, `student/lesson.html`, `student/exam.html`, `student/progress.html`, `student/profile.html`, `student/challenges.html`)
  3. Teacher Portal (`teacher/dashboard.html`, `api/teacher/*`)
  4. Admin Portal (`admin/dashboard.html`, `admin/students.html`, `admin/teachers.html`, `admin/assessments.html`, `api/admin/*`)

## 2. Exact File Count

### Total Files
**Exact Total Files Present in Project**: **210**

### File Counts by Type
- **HTML files (.html)**: 20
- **PHP files (.php)**: 65
- **JavaScript files (.js)**: 44
- **CSS files (.css)**: 9
- **JSON files (.json)**: 8
- **TypeScript / TSX files (.ts, .tsx)**: 5
- **SQL files (.sql)**: 3
- **Python files (.py)**: 11
- **Python Bytecode Cache (.pyc)**: 7
- **Image files (.png, .jpg)**: 32 (21 PNG, 11 JPG)
- **JavaScript Module files (.mjs)**: 2
- **Environment / Config files (.example, .gitignore, .lock)**: 3
- **Plain Text files (.txt)**: 1

### Total Directories
**Exact Subdirectories Count**: **38** (39 total including workspace root `/`)

### Functional Category Breakdown
- **Application / Source Code Files**: 146 files (HTML, PHP API/Includes, Core JS, CSS, TS/TSX)
- **Media Assets**: 32 files (Images, Logos, Character Sprites)
- **Configuration & Tooling**: 9 files (`package.json`, `tsconfig.json`, `metadata.json`, `.eslintrc.json`, `eslint.config.mjs`, `postcss.config.mjs`, `bun.lock`, `.env.example`, `.gitignore`)
- **Data Stores & Exports**: 4 files (`data/db_store.json`, `data/chapter_exams.json`, `data/curriculum_export.json`, `sps_curriculum_complete_seed.json`)
- **Curriculum Generator Scripts & Cache**: 19 files (12 Python/JS scripts + 7 `.pyc` Python cache files in `scripts/__pycache__/`)

## 3. Complete Directory Tree

```
/
├── admin/
├── api/
│   ├── academic_groups/
│   ├── admin/
│   ├── auth/
│   ├── chapters/
│   ├── classes/
│   ├── courses/
│   ├── exams/
│   ├── gamification/
│   ├── lessons/
│   │   ├── blocks/
│   ├── projects/
│   ├── student/
│   ├── teacher/
├── app/
├── assets/
│   ├── cody/
│   ├── courses/
│   ├── images/
│   ├── paths/
│   ├── shady/
├── config/
├── css/
├── data/
├── database/
├── hooks/
├── includes/
├── js/
├── lib/
├── middleware/
├── scripts/
│   ├── __pycache__/
├── src/
│   ├── assets/
│   │   ├── images/
├── student/
├── teacher/
```

## 4. File-by-File Inventory

This section details every single file present in the repository.

### 1. `/.env.example`

**Type:** Environment Config Example

**Role:** Component / file serving .env.example functionality in the platform.

**Responsibilities:**
- Implements core functionality for `.env.example`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `root` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** YES

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 2. `/.eslintrc.json`

**Type:** JSON

**Role:** Component / file serving .eslintrc.json functionality in the platform.

**Responsibilities:**
- Implements core functionality for `.eslintrc.json`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `root` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** PARTIALLY ACTIVE (Next.js Boilerplate / Tooling)

---

### 3. `/.gitignore`

**Type:** Git Ignore

**Role:** Component / file serving .gitignore functionality in the platform.

**Responsibilities:**
- Implements core functionality for `.gitignore`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `root` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 4. `/Yellow_star_character_smiling.png`

**Type:** Image Asset

**Role:** Component / file serving Yellow_star_character_smiling.png functionality in the platform.

**Responsibilities:**
- Implements core functionality for `Yellow_star_character_smiling.png`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `root` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 5. `/about.html`

**Type:** HTML

**Role:** Component / file serving about.html functionality in the platform.

**Responsibilities:**
- Implements core functionality for `about.html`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `root` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 6. `/admin/assessments.html`

**Type:** HTML

**Role:** Component / file serving admin functionality in the platform.

**Responsibilities:**
- Implements core functionality for `assessments.html`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `admin` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** YES

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 7. `/admin/dashboard.html`

**Type:** HTML

**Role:** Component / file serving admin functionality in the platform.

**Responsibilities:**
- Implements core functionality for `dashboard.html`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `admin` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 8. `/admin/students.html`

**Type:** HTML

**Role:** Component / file serving admin functionality in the platform.

**Responsibilities:**
- Implements core functionality for `students.html`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `admin` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 9. `/admin/teachers.html`

**Type:** HTML

**Role:** Component / file serving admin functionality in the platform.

**Responsibilities:**
- Implements core functionality for `teachers.html`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `admin` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 10. `/api/academic_groups/list.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `list.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/academic_groups` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 11. `/api/admin/get_student_profile.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `get_student_profile.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/admin` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 12. `/api/admin/get_students.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `get_students.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/admin` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 13. `/api/admin/get_teachers.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `get_teachers.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/admin` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 14. `/api/admin/metrics.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `metrics.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/admin` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 15. `/api/admin/students.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `students.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/admin` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 16. `/api/admin/teachers.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `teachers.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/admin` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 17. `/api/auth/bootstrap_admin.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `bootstrap_admin.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/auth` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** YES

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 18. `/api/auth/login.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `login.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/auth` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** YES

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 19. `/api/auth/logout.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `logout.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/auth` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** YES

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 20. `/api/auth/me.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `me.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/auth` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** YES

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 21. `/api/auth/signup.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `signup.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/auth` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** YES

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 22. `/api/chapters/create.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `create.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/chapters` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 23. `/api/chapters/delete.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `delete.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/chapters` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 24. `/api/chapters/get.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `get.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/chapters` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 25. `/api/chapters/list.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `list.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/chapters` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 26. `/api/chapters/update.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `update.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/chapters` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 27. `/api/classes/list.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `list.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/classes` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 28. `/api/courses/create.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `create.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/courses` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 29. `/api/courses/delete.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `delete.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/courses` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 30. `/api/courses/detail.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `detail.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/courses` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 31. `/api/courses/enroll.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `enroll.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/courses` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 32. `/api/courses/get.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `get.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/courses` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 33. `/api/courses/list.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `list.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/courses` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 34. `/api/courses/update.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `update.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/courses` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 35. `/api/exams/create.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `create.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/exams` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** YES

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 36. `/api/exams/get.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `get.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/exams` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** YES

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 37. `/api/exams/list.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `list.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/exams` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** YES

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 38. `/api/exams/submit.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `submit.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/exams` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** YES

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 39. `/api/gamification/status.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `status.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/gamification` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 40. `/api/lessons/blocks/create.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `create.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/lessons/blocks` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 41. `/api/lessons/blocks/delete.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `delete.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/lessons/blocks` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 42. `/api/lessons/blocks/list.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `list.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/lessons/blocks` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 43. `/api/lessons/blocks/update.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `update.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/lessons/blocks` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 44. `/api/lessons/complete.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `complete.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/lessons` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 45. `/api/lessons/create.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `create.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/lessons` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 46. `/api/lessons/delete.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `delete.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/lessons` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 47. `/api/lessons/get.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `get.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/lessons` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 48. `/api/lessons/list.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `list.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/lessons` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 49. `/api/lessons/update.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `update.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/lessons` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 50. `/api/projects/create.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `create.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/projects` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 51. `/api/projects/get.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `get.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/projects` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 52. `/api/projects/list.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `list.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/projects` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 53. `/api/projects/submit.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `submit.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/projects` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 54. `/api/student/dashboard.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `dashboard.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/student` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 55. `/api/student/detailed_profile.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `detailed_profile.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/student` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 56. `/api/student/profile.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `profile.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/student` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 57. `/api/student/progress.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `progress.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/student` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 58. `/api/teacher/grade_submission.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `grade_submission.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/teacher` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 59. `/api/teacher/students.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `students.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/teacher` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 60. `/api/teacher/submissions.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `submissions.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api/teacher` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 61. `/api/test_debug.php`

**Type:** PHP

**Role:** Component / file serving api functionality in the platform.

**Responsibilities:**
- Implements core functionality for `test_debug.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `api` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 62. `/app/globals.css`

**Type:** CSS

**Role:** Component / file serving app functionality in the platform.

**Responsibilities:**
- Implements core functionality for `globals.css`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `app` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** PARTIALLY ACTIVE (Next.js Boilerplate / Tooling)

---

### 63. `/app/layout.tsx`

**Type:** TypeScript

**Role:** Component / file serving app functionality in the platform.

**Responsibilities:**
- Implements core functionality for `layout.tsx`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `app` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** PARTIALLY ACTIVE (Next.js Boilerplate / Tooling)

---

### 64. `/assets/cody/cody.png`

**Type:** Image Asset

**Role:** Component / file serving assets functionality in the platform.

**Responsibilities:**
- Implements core functionality for `cody.png`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `assets/cody` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 65. `/assets/courses/ai.png`

**Type:** Image Asset

**Role:** Component / file serving assets functionality in the platform.

**Responsibilities:**
- Implements core functionality for `ai.png`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `assets/courses` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE

---

### 66. `/assets/courses/algo.png`

**Type:** Image Asset

**Role:** Component / file serving assets functionality in the platform.

**Responsibilities:**
- Implements core functionality for `algo.png`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `assets/courses` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE

---

### 67. `/assets/courses/design.png`

**Type:** Image Asset

**Role:** Component / file serving assets functionality in the platform.

**Responsibilities:**
- Implements core functionality for `design.png`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `assets/courses` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE

---

### 68. `/assets/courses/game.png`

**Type:** Image Asset

**Role:** Component / file serving assets functionality in the platform.

**Responsibilities:**
- Implements core functionality for `game.png`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `assets/courses` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE

---

### 69. `/assets/courses/gamedev.png`

**Type:** Image Asset

**Role:** Component / file serving assets functionality in the platform.

**Responsibilities:**
- Implements core functionality for `gamedev.png`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `assets/courses` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE

---

### 70. `/assets/courses/prog.png`

**Type:** Image Asset

**Role:** Component / file serving assets functionality in the platform.

**Responsibilities:**
- Implements core functionality for `prog.png`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `assets/courses` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE

---

### 71. `/assets/courses/robotics.png`

**Type:** Image Asset

**Role:** Component / file serving assets functionality in the platform.

**Responsibilities:**
- Implements core functionality for `robotics.png`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `assets/courses` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE

---

### 72. `/assets/courses/scratch.png`

**Type:** Image Asset

**Role:** Component / file serving assets functionality in the platform.

**Responsibilities:**
- Implements core functionality for `scratch.png`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `assets/courses` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE

---

### 73. `/assets/courses/web.png`

**Type:** Image Asset

**Role:** Component / file serving assets functionality in the platform.

**Responsibilities:**
- Implements core functionality for `web.png`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `assets/courses` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE

---

### 74. `/assets/images/Astronaut_holding_coding.png`

**Type:** Image Asset

**Role:** Component / file serving assets functionality in the platform.

**Responsibilities:**
- Implements core functionality for `Astronaut_holding_coding.png`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `assets/images` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 75. `/assets/images/Astronaut_robot_holding_star.png`

**Type:** Image Asset

**Role:** Component / file serving assets functionality in the platform.

**Responsibilities:**
- Implements core functionality for `Astronaut_robot_holding_star.png`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `assets/images` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 76. `/assets/images/Green_alien_waving_in_UFO.png`

**Type:** Image Asset

**Role:** Component / file serving assets functionality in the platform.

**Responsibilities:**
- Implements core functionality for `Green_alien_waving_in_UFO.png`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `assets/images` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 77. `/assets/images/Robot_waving_in_coding_banner.png`

**Type:** Image Asset

**Role:** Component / file serving assets functionality in the platform.

**Responsibilities:**
- Implements core functionality for `Robot_waving_in_coding_banner.png`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `assets/images` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 78. `/assets/images/Violet_planet_character_smiling.png`

**Type:** Image Asset

**Role:** Component / file serving assets functionality in the platform.

**Responsibilities:**
- Implements core functionality for `Violet_planet_character_smiling.png`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `assets/images` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 79. `/assets/images/Yellow_star_character_smiling.png`

**Type:** Image Asset

**Role:** Component / file serving assets functionality in the platform.

**Responsibilities:**
- Implements core functionality for `Yellow_star_character_smiling.png`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `assets/images` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 80. `/assets/images/astronaut_hologram_scene.jpg`

**Type:** Image Asset

**Role:** Component / file serving assets functionality in the platform.

**Responsibilities:**
- Implements core functionality for `astronaut_hologram_scene.jpg`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `assets/images` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 81. `/assets/paths/prep.png`

**Type:** Image Asset

**Role:** Component / file serving assets functionality in the platform.

**Responsibilities:**
- Implements core functionality for `prep.png`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `assets/paths` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 82. `/assets/paths/primary.png`

**Type:** Image Asset

**Role:** Component / file serving assets functionality in the platform.

**Responsibilities:**
- Implements core functionality for `primary.png`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `assets/paths` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 83. `/assets/paths/secondary.png`

**Type:** Image Asset

**Role:** Component / file serving assets functionality in the platform.

**Responsibilities:**
- Implements core functionality for `secondary.png`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `assets/paths` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 84. `/assets/shady/shady.png`

**Type:** Image Asset

**Role:** Component / file serving assets functionality in the platform.

**Responsibilities:**
- Implements core functionality for `shady.png`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `assets/shady` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 85. `/astronaut_hologram_scene.jpg`

**Type:** Image Asset

**Role:** Component / file serving astronaut_hologram_scene.jpg functionality in the platform.

**Responsibilities:**
- Implements core functionality for `astronaut_hologram_scene.jpg`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `root` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 86. `/bun.lock`

**Type:** Package Lock File

**Role:** Component / file serving bun.lock functionality in the platform.

**Responsibilities:**
- Implements core functionality for `bun.lock`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `root` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** PARTIALLY ACTIVE (Next.js Boilerplate / Tooling)

---

### 87. `/challenges.html`

**Type:** HTML

**Role:** Component / file serving challenges.html functionality in the platform.

**Responsibilities:**
- Implements core functionality for `challenges.html`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `root` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 88. `/config/config.php`

**Type:** PHP

**Role:** Component / file serving config functionality in the platform.

**Responsibilities:**
- Implements core functionality for `config.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `config` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 89. `/config/database.php`

**Type:** PHP

**Role:** Component / file serving config functionality in the platform.

**Responsibilities:**
- Implements core functionality for `database.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `config` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 90. `/courses.html`

**Type:** HTML

**Role:** Component / file serving courses.html functionality in the platform.

**Responsibilities:**
- Implements core functionality for `courses.html`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `root` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE

---

### 91. `/coursesData.js`

**Type:** JavaScript

**Role:** Component / file serving coursesData.js functionality in the platform.

**Responsibilities:**
- Implements core functionality for `coursesData.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `root` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE

---

### 92. `/css/components.css`

**Type:** CSS

**Role:** Component / file serving css functionality in the platform.

**Responsibilities:**
- Implements core functionality for `components.css`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `css` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 93. `/css/dashboard.css`

**Type:** CSS

**Role:** Component / file serving css functionality in the platform.

**Responsibilities:**
- Implements core functionality for `dashboard.css`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `css` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 94. `/css/exam.css`

**Type:** CSS

**Role:** Component / file serving css functionality in the platform.

**Responsibilities:**
- Implements core functionality for `exam.css`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `css` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** YES

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 95. `/css/global.css`

**Type:** CSS

**Role:** Component / file serving css functionality in the platform.

**Responsibilities:**
- Implements core functionality for `global.css`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `css` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 96. `/css/landing.css`

**Type:** CSS

**Role:** Component / file serving css functionality in the platform.

**Responsibilities:**
- Implements core functionality for `landing.css`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `css` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 97. `/css/lesson.css`

**Type:** CSS

**Role:** Component / file serving css functionality in the platform.

**Responsibilities:**
- Implements core functionality for `lesson.css`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `css` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE

---

### 98. `/css/style.css`

**Type:** CSS

**Role:** Component / file serving css functionality in the platform.

**Responsibilities:**
- Implements core functionality for `style.css`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `css` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 99. `/data/chapter_exams.js`

**Type:** JavaScript

**Role:** Component / file serving data functionality in the platform.

**Responsibilities:**
- Implements core functionality for `chapter_exams.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `data` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** YES

**Curriculum relevance:** YES

**Runtime status:** ACTIVE

---

### 100. `/data/chapter_exams.json`

**Type:** JSON

**Role:** Component / file serving data functionality in the platform.

**Responsibilities:**
- Implements core functionality for `chapter_exams.json`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `data` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** YES

**Curriculum relevance:** YES

**Runtime status:** PARTIALLY ACTIVE / FALLBACK DATA

---

### 101. `/data/chapters.js`

**Type:** JavaScript

**Role:** Component / file serving data functionality in the platform.

**Responsibilities:**
- Implements core functionality for `chapters.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `data` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE

---

### 102. `/data/code_puzzles_curriculum.js`

**Type:** JavaScript

**Role:** Component / file serving data functionality in the platform.

**Responsibilities:**
- Implements core functionality for `code_puzzles_curriculum.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `data` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** PARTIALLY ACTIVE / FALLBACK DATA

---

### 103. `/data/courses.js`

**Type:** JavaScript

**Role:** Component / file serving data functionality in the platform.

**Responsibilities:**
- Implements core functionality for `courses.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `data` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE

---

### 104. `/data/coursesData.js`

**Type:** JavaScript

**Role:** Component / file serving data functionality in the platform.

**Responsibilities:**
- Implements core functionality for `coursesData.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `data` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** PARTIALLY ACTIVE / FALLBACK DATA

---

### 105. `/data/curriculum_export.json`

**Type:** JSON

**Role:** Component / file serving data functionality in the platform.

**Responsibilities:**
- Implements core functionality for `curriculum_export.json`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `data` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** PARTIALLY ACTIVE / FALLBACK DATA

---

### 106. `/data/curriculum_index.js`

**Type:** JavaScript

**Role:** Component / file serving data functionality in the platform.

**Responsibilities:**
- Implements core functionality for `curriculum_index.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `data` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE

---

### 107. `/data/db_store.js`

**Type:** JavaScript

**Role:** Component / file serving data functionality in the platform.

**Responsibilities:**
- Implements core functionality for `db_store.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `data` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 108. `/data/db_store.json`

**Type:** JSON

**Role:** Component / file serving data functionality in the platform.

**Responsibilities:**
- Implements core functionality for `db_store.json`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `data` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 109. `/data/digital_creators_curriculum.js`

**Type:** JavaScript

**Role:** Component / file serving data functionality in the platform.

**Responsibilities:**
- Implements core functionality for `digital_creators_curriculum.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `data` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** PARTIALLY ACTIVE / FALLBACK DATA

---

### 110. `/data/frontend_builder_curriculum.js`

**Type:** JavaScript

**Role:** Component / file serving data functionality in the platform.

**Responsibilities:**
- Implements core functionality for `frontend_builder_curriculum.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `data` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** PARTIALLY ACTIVE / FALLBACK DATA

---

### 111. `/data/javascript_developer_curriculum.js`

**Type:** JavaScript

**Role:** Component / file serving data functionality in the platform.

**Responsibilities:**
- Implements core functionality for `javascript_developer_curriculum.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `data` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** PARTIALLY ACTIVE / FALLBACK DATA

---

### 112. `/data/js_adventures_curriculum.js`

**Type:** JavaScript

**Role:** Component / file serving data functionality in the platform.

**Responsibilities:**
- Implements core functionality for `js_adventures_curriculum.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `data` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** PARTIALLY ACTIVE / FALLBACK DATA

---

### 113. `/data/js_foundations_curriculum.js`

**Type:** JavaScript

**Role:** Component / file serving data functionality in the platform.

**Responsibilities:**
- Implements core functionality for `js_foundations_curriculum.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `data` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** PARTIALLY ACTIVE / FALLBACK DATA

---

### 114. `/data/lessons.js`

**Type:** JavaScript

**Role:** Component / file serving data functionality in the platform.

**Responsibilities:**
- Implements core functionality for `lessons.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `data` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE

---

### 115. `/data/programming_foundations_curriculum.js`

**Type:** JavaScript

**Role:** Component / file serving data functionality in the platform.

**Responsibilities:**
- Implements core functionality for `programming_foundations_curriculum.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `data` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** PARTIALLY ACTIVE / FALLBACK DATA

---

### 116. `/data/python_adventures_curriculum.js`

**Type:** JavaScript

**Role:** Component / file serving data functionality in the platform.

**Responsibilities:**
- Implements core functionality for `python_adventures_curriculum.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `data` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** PARTIALLY ACTIVE / FALLBACK DATA

---

### 117. `/data/python_developer_curriculum.js`

**Type:** JavaScript

**Role:** Component / file serving data functionality in the platform.

**Responsibilities:**
- Implements core functionality for `python_developer_curriculum.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `data` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** PARTIALLY ACTIVE / FALLBACK DATA

---

### 118. `/data/python_foundations_curriculum.js`

**Type:** JavaScript

**Role:** Component / file serving data functionality in the platform.

**Responsibilities:**
- Implements core functionality for `python_foundations_curriculum.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `data` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** PARTIALLY ACTIVE / FALLBACK DATA

---

### 119. `/data/scratch_adventures_curriculum.js`

**Type:** JavaScript

**Role:** Component / file serving data functionality in the platform.

**Responsibilities:**
- Implements core functionality for `scratch_adventures_curriculum.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `data` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** PARTIALLY ACTIVE / FALLBACK DATA

---

### 120. `/data/web_adventures_curriculum.js`

**Type:** JavaScript

**Role:** Component / file serving data functionality in the platform.

**Responsibilities:**
- Implements core functionality for `web_adventures_curriculum.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `data` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** PARTIALLY ACTIVE / FALLBACK DATA

---

### 121. `/data/web_explorers_curriculum.js`

**Type:** JavaScript

**Role:** Component / file serving data functionality in the platform.

**Responsibilities:**
- Implements core functionality for `web_explorers_curriculum.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `data` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** PARTIALLY ACTIVE / FALLBACK DATA

---

### 122. `/database/database.sql`

**Type:** SQL

**Role:** Component / file serving database functionality in the platform.

**Responsibilities:**
- Implements core functionality for `database.sql`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `database` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 123. `/database/seed.sql`

**Type:** SQL

**Role:** Component / file serving database functionality in the platform.

**Responsibilities:**
- Implements core functionality for `seed.sql`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `database` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 124. `/database/seed_curriculum.php`

**Type:** PHP

**Role:** Component / file serving database functionality in the platform.

**Responsibilities:**
- Implements core functionality for `seed_curriculum.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `database` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE

---

### 125. `/database/seed_curriculum.sql`

**Type:** SQL

**Role:** Component / file serving database functionality in the platform.

**Responsibilities:**
- Implements core functionality for `seed_curriculum.sql`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `database` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE

---

### 126. `/database/seed_exams.php`

**Type:** PHP

**Role:** Component / file serving database functionality in the platform.

**Responsibilities:**
- Implements core functionality for `seed_exams.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `database` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** YES

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 127. `/eslint.config.mjs`

**Type:** JavaScript Module

**Role:** Component / file serving eslint.config.mjs functionality in the platform.

**Responsibilities:**
- Implements core functionality for `eslint.config.mjs`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `root` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** PARTIALLY ACTIVE (Next.js Boilerplate / Tooling)

---

### 128. `/hooks/use-mobile.ts`

**Type:** TypeScript

**Role:** Component / file serving hooks functionality in the platform.

**Responsibilities:**
- Implements core functionality for `use-mobile.ts`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `hooks` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** PARTIALLY ACTIVE (Next.js Boilerplate / Tooling)

---

### 129. `/includes/curriculum_helpers.php`

**Type:** PHP

**Role:** Component / file serving includes functionality in the platform.

**Responsibilities:**
- Implements core functionality for `curriculum_helpers.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `includes` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 130. `/includes/exam_questions.php`

**Type:** PHP

**Role:** Component / file serving includes functionality in the platform.

**Responsibilities:**
- Implements core functionality for `exam_questions.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `includes` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** YES

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 131. `/includes/helpers.php`

**Type:** PHP

**Role:** Component / file serving includes functionality in the platform.

**Responsibilities:**
- Implements core functionality for `helpers.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `includes` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 132. `/includes/response.php`

**Type:** PHP

**Role:** Component / file serving includes functionality in the platform.

**Responsibilities:**
- Implements core functionality for `response.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `includes` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 133. `/index.html`

**Type:** HTML

**Role:** Component / file serving index.html functionality in the platform.

**Responsibilities:**
- Implements core functionality for `index.html`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `root` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 134. `/js/code-runner.js`

**Type:** JavaScript

**Role:** Component / file serving js functionality in the platform.

**Responsibilities:**
- Implements core functionality for `code-runner.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `js` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 135. `/js/components.js`

**Type:** JavaScript

**Role:** Component / file serving js functionality in the platform.

**Responsibilities:**
- Implements core functionality for `components.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `js` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 136. `/js/gamification.js`

**Type:** JavaScript

**Role:** Component / file serving js functionality in the platform.

**Responsibilities:**
- Implements core functionality for `gamification.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `js` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 137. `/js/session.js`

**Type:** JavaScript

**Role:** Component / file serving js functionality in the platform.

**Responsibilities:**
- Implements core functionality for `session.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `js` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** YES

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 138. `/js/theme.js`

**Type:** JavaScript

**Role:** Component / file serving js functionality in the platform.

**Responsibilities:**
- Implements core functionality for `theme.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `js` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 139. `/lib/utils.ts`

**Type:** TypeScript

**Role:** Component / file serving lib functionality in the platform.

**Responsibilities:**
- Implements core functionality for `utils.ts`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `lib` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** PARTIALLY ACTIVE (Next.js Boilerplate / Tooling)

---

### 140. `/login.html`

**Type:** HTML

**Role:** Component / file serving login.html functionality in the platform.

**Responsibilities:**
- Implements core functionality for `login.html`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `root` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** YES

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 141. `/metadata.json`

**Type:** JSON

**Role:** Component / file serving metadata.json functionality in the platform.

**Responsibilities:**
- Implements core functionality for `metadata.json`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `root` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 142. `/middleware/admin.php`

**Type:** PHP

**Role:** Component / file serving middleware functionality in the platform.

**Responsibilities:**
- Implements core functionality for `admin.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `middleware` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 143. `/middleware/auth.php`

**Type:** PHP

**Role:** Component / file serving middleware functionality in the platform.

**Responsibilities:**
- Implements core functionality for `auth.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `middleware` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** YES

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 144. `/middleware/csrf.php`

**Type:** PHP

**Role:** Component / file serving middleware functionality in the platform.

**Responsibilities:**
- Implements core functionality for `csrf.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `middleware` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 145. `/middleware/student.php`

**Type:** PHP

**Role:** Component / file serving middleware functionality in the platform.

**Responsibilities:**
- Implements core functionality for `student.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `middleware` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 146. `/middleware/teacher.php`

**Type:** PHP

**Role:** Component / file serving middleware functionality in the platform.

**Responsibilities:**
- Implements core functionality for `teacher.php`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `middleware` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE / EMULATED VIA SERVER.JS (PHP Backend Architecture)

---

### 147. `/next-env.d.ts`

**Type:** TypeScript

**Role:** Component / file serving next-env.d.ts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `next-env.d.ts`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `root` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** PARTIALLY ACTIVE (Next.js Boilerplate / Tooling)

---

### 148. `/next.config.ts`

**Type:** TypeScript

**Role:** Component / file serving next.config.ts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `next.config.ts`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `root` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** PARTIALLY ACTIVE (Next.js Boilerplate / Tooling)

---

### 149. `/package.json`

**Type:** JSON

**Role:** Component / file serving package.json functionality in the platform.

**Responsibilities:**
- Implements core functionality for `package.json`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `root` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 150. `/postcss.config.mjs`

**Type:** JavaScript Module

**Role:** Component / file serving postcss.config.mjs functionality in the platform.

**Responsibilities:**
- Implements core functionality for `postcss.config.mjs`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `root` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** PARTIALLY ACTIVE (Next.js Boilerplate / Tooling)

---

### 151. `/scripts/__pycache__/build_complete_python_curriculum.cpython-310.pyc`

**Type:** Python Bytecode Cache

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `build_complete_python_curriculum.cpython-310.pyc`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts/__pycache__` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** LEGACY / BUILD CACHE

---

### 152. `/scripts/__pycache__/chapters_4_to_10.cpython-310.pyc`

**Type:** Python Bytecode Cache

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `chapters_4_to_10.cpython-310.pyc`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts/__pycache__` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** LEGACY / BUILD CACHE

---

### 153. `/scripts/__pycache__/chapters_5_to_10.cpython-310.pyc`

**Type:** Python Bytecode Cache

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `chapters_5_to_10.cpython-310.pyc`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts/__pycache__` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** LEGACY / BUILD CACHE

---

### 154. `/scripts/__pycache__/chapters_6_to_10.cpython-310.pyc`

**Type:** Python Bytecode Cache

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `chapters_6_to_10.cpython-310.pyc`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts/__pycache__` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** LEGACY / BUILD CACHE

---

### 155. `/scripts/__pycache__/chapters_7_to_10.cpython-310.pyc`

**Type:** Python Bytecode Cache

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `chapters_7_to_10.cpython-310.pyc`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts/__pycache__` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** LEGACY / BUILD CACHE

---

### 156. `/scripts/__pycache__/chapters_8_to_10.cpython-310.pyc`

**Type:** Python Bytecode Cache

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `chapters_8_to_10.cpython-310.pyc`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts/__pycache__` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** LEGACY / BUILD CACHE

---

### 157. `/scripts/__pycache__/generate_all_10_chapters.cpython-310.pyc`

**Type:** Python Bytecode Cache

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `generate_all_10_chapters.cpython-310.pyc`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts/__pycache__` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** LEGACY / BUILD CACHE

---

### 158. `/scripts/append_primary_exams.js`

**Type:** JavaScript

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `append_primary_exams.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** YES

**Curriculum relevance:** NO

**Runtime status:** LEGACY / UTILITY SCRIPT

---

### 159. `/scripts/build_all_pyadv_course.py`

**Type:** Python Script

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `build_all_pyadv_course.py`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** LEGACY / UTILITY SCRIPT

---

### 160. `/scripts/build_code_puzzles.js`

**Type:** JavaScript

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `build_code_puzzles.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** LEGACY / UTILITY SCRIPT

---

### 161. `/scripts/build_complete_python_curriculum.py`

**Type:** Python Script

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `build_complete_python_curriculum.py`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** LEGACY / UTILITY SCRIPT

---

### 162. `/scripts/build_digital_creators.js`

**Type:** JavaScript

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `build_digital_creators.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** LEGACY / UTILITY SCRIPT

---

### 163. `/scripts/build_full_curriculum.py`

**Type:** Python Script

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `build_full_curriculum.py`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** LEGACY / UTILITY SCRIPT

---

### 164. `/scripts/build_full_curriculum_script.js`

**Type:** JavaScript

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `build_full_curriculum_script.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** LEGACY / UTILITY SCRIPT

---

### 165. `/scripts/build_game_makers.js`

**Type:** JavaScript

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `build_game_makers.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** LEGACY / UTILITY SCRIPT

---

### 166. `/scripts/build_python_adventures.js`

**Type:** JavaScript

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `build_python_adventures.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** LEGACY / UTILITY SCRIPT

---

### 167. `/scripts/build_scratch_adventures.js`

**Type:** JavaScript

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `build_scratch_adventures.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** LEGACY / UTILITY SCRIPT

---

### 168. `/scripts/build_tier1_exams.js`

**Type:** JavaScript

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `build_tier1_exams.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** YES

**Curriculum relevance:** NO

**Runtime status:** LEGACY / UTILITY SCRIPT

---

### 169. `/scripts/build_web_explorers.js`

**Type:** JavaScript

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `build_web_explorers.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** LEGACY / UTILITY SCRIPT

---

### 170. `/scripts/chapters_4_to_10.py`

**Type:** Python Script

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `chapters_4_to_10.py`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** LEGACY / UTILITY SCRIPT

---

### 171. `/scripts/chapters_5_to_10.py`

**Type:** Python Script

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `chapters_5_to_10.py`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** LEGACY / UTILITY SCRIPT

---

### 172. `/scripts/chapters_6_to_10.py`

**Type:** Python Script

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `chapters_6_to_10.py`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** LEGACY / UTILITY SCRIPT

---

### 173. `/scripts/chapters_7_to_10.py`

**Type:** Python Script

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `chapters_7_to_10.py`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** LEGACY / UTILITY SCRIPT

---

### 174. `/scripts/chapters_8_to_10.py`

**Type:** Python Script

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `chapters_8_to_10.py`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** LEGACY / UTILITY SCRIPT

---

### 175. `/scripts/chapters_data.js`

**Type:** JavaScript

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `chapters_data.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** LEGACY / UTILITY SCRIPT

---

### 176. `/scripts/export_exams_json.js`

**Type:** JavaScript

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `export_exams_json.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** YES

**Curriculum relevance:** NO

**Runtime status:** LEGACY / UTILITY SCRIPT

---

### 177. `/scripts/generate_all_10_chapters.py`

**Type:** Python Script

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `generate_all_10_chapters.py`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** LEGACY / UTILITY SCRIPT

---

### 178. `/scripts/generate_all_chapters.js`

**Type:** JavaScript

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `generate_all_chapters.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** LEGACY / UTILITY SCRIPT

---

### 179. `/scripts/generate_complete_curriculum.js`

**Type:** JavaScript

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `generate_complete_curriculum.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** LEGACY / UTILITY SCRIPT

---

### 180. `/scripts/generate_curriculum_sql.js`

**Type:** JavaScript

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `generate_curriculum_sql.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** LEGACY / UTILITY SCRIPT

---

### 181. `/scripts/generate_pyadv_complete.py`

**Type:** Python Script

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `generate_pyadv_complete.py`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** LEGACY / UTILITY SCRIPT

---

### 182. `/scripts/generate_tier1.js`

**Type:** JavaScript

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `generate_tier1.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** LEGACY / UTILITY SCRIPT

---

### 183. `/scripts/make_pyadv_curriculum.py`

**Type:** Python Script

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `make_pyadv_curriculum.py`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** LEGACY / UTILITY SCRIPT

---

### 184. `/scripts/merge_curriculum.js`

**Type:** JavaScript

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `merge_curriculum.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** LEGACY / UTILITY SCRIPT

---

### 185. `/scripts/scratch_helpers.js`

**Type:** JavaScript

**Role:** Component / file serving scripts functionality in the platform.

**Responsibilities:**
- Implements core functionality for `scratch_helpers.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `scripts` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** LEGACY / UTILITY SCRIPT

---

### 186. `/server.js`

**Type:** JavaScript

**Role:** Component / file serving server.js functionality in the platform.

**Responsibilities:**
- Implements core functionality for `server.js`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `root` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** YES
- Tables / Stores: `profiles`, `courses`, `lessons`, `course_enrollments`, `lesson_progress`, `db_store.json`
- Operations: SELECT, INSERT, UPDATE, DELETE / JSON File Read & Write

**Authentication relevance:** YES

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 187. `/signup.html`

**Type:** HTML

**Role:** Component / file serving signup.html functionality in the platform.

**Responsibilities:**
- Implements core functionality for `signup.html`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `root` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** YES

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 188. `/sps_curriculum_complete_content.txt`

**Type:** Text Data File

**Role:** Component / file serving sps_curriculum_complete_content.txt functionality in the platform.

**Responsibilities:**
- Implements core functionality for `sps_curriculum_complete_content.txt`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `root` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** LEGACY / SEED EXPORT

---

### 189. `/sps_curriculum_complete_seed.json`

**Type:** JSON

**Role:** Component / file serving sps_curriculum_complete_seed.json functionality in the platform.

**Responsibilities:**
- Implements core functionality for `sps_curriculum_complete_seed.json`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `root` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** LEGACY / SEED EXPORT

---

### 190. `/src/assets/images/astronaut_hologram_scene_1788787175136.jpg`

**Type:** Image Asset

**Role:** Component / file serving src functionality in the platform.

**Responsibilities:**
- Implements core functionality for `astronaut_hologram_scene_1788787175136.jpg`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `src/assets/images` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 191. `/src/assets/images/cody_mascot_1788621173927.jpg`

**Type:** Image Asset

**Role:** Component / file serving src functionality in the platform.

**Responsibilities:**
- Implements core functionality for `cody_mascot_1788621173927.jpg`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `src/assets/images` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 192. `/src/assets/images/course_ai_chip_1788621225832.jpg`

**Type:** Image Asset

**Role:** Component / file serving src functionality in the platform.

**Responsibilities:**
- Implements core functionality for `course_ai_chip_1788621225832.jpg`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `src/assets/images` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE

---

### 193. `/src/assets/images/course_digital_design_1788621260594.jpg`

**Type:** Image Asset

**Role:** Component / file serving src functionality in the platform.

**Responsibilities:**
- Implements core functionality for `course_digital_design_1788621260594.jpg`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `src/assets/images` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE

---

### 194. `/src/assets/images/course_prog_laptop_1788621208329.jpg`

**Type:** Image Asset

**Role:** Component / file serving src functionality in the platform.

**Responsibilities:**
- Implements core functionality for `course_prog_laptop_1788621208329.jpg`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `src/assets/images` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE

---

### 195. `/src/assets/images/course_robotics_1788621244018.jpg`

**Type:** Image Asset

**Role:** Component / file serving src functionality in the platform.

**Responsibilities:**
- Implements core functionality for `course_robotics_1788621244018.jpg`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `src/assets/images` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE

---

### 196. `/src/assets/images/path_prep_sprout_1788621277921.jpg`

**Type:** Image Asset

**Role:** Component / file serving src functionality in the platform.

**Responsibilities:**
- Implements core functionality for `path_prep_sprout_1788621277921.jpg`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `src/assets/images` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 197. `/src/assets/images/path_secondary_cube_1788621295025.jpg`

**Type:** Image Asset

**Role:** Component / file serving src functionality in the platform.

**Responsibilities:**
- Implements core functionality for `path_secondary_cube_1788621295025.jpg`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `src/assets/images` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 198. `/src/assets/images/shady_student_avatar_1788621191543.jpg`

**Type:** Image Asset

**Role:** Component / file serving src functionality in the platform.

**Responsibilities:**
- Implements core functionality for `shady_student_avatar_1788621191543.jpg`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `src/assets/images` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 199. `/student/challenges.html`

**Type:** HTML

**Role:** Component / file serving student functionality in the platform.

**Responsibilities:**
- Implements core functionality for `challenges.html`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `student` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 200. `/student/chapter.html`

**Type:** HTML

**Role:** Component / file serving student functionality in the platform.

**Responsibilities:**
- Implements core functionality for `chapter.html`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `student` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE

---

### 201. `/student/course.html`

**Type:** HTML

**Role:** Component / file serving student functionality in the platform.

**Responsibilities:**
- Implements core functionality for `course.html`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `student` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE

---

### 202. `/student/courses.html`

**Type:** HTML

**Role:** Component / file serving student functionality in the platform.

**Responsibilities:**
- Implements core functionality for `courses.html`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `student` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE

---

### 203. `/student/dashboard.html`

**Type:** HTML

**Role:** Component / file serving student functionality in the platform.

**Responsibilities:**
- Implements core functionality for `dashboard.html`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `student` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 204. `/student/exam.html`

**Type:** HTML

**Role:** Component / file serving student functionality in the platform.

**Responsibilities:**
- Implements core functionality for `exam.html`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `student` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** YES

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 205. `/student/lesson.html`

**Type:** HTML

**Role:** Component / file serving student functionality in the platform.

**Responsibilities:**
- Implements core functionality for `lesson.html`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `student` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** YES

**Runtime status:** ACTIVE

---

### 206. `/student/profile.html`

**Type:** HTML

**Role:** Component / file serving student functionality in the platform.

**Responsibilities:**
- Implements core functionality for `profile.html`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `student` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 207. `/student/progress.html`

**Type:** HTML

**Role:** Component / file serving student functionality in the platform.

**Responsibilities:**
- Implements core functionality for `progress.html`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `student` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 208. `/style.css`

**Type:** CSS

**Role:** Component / file serving style.css functionality in the platform.

**Responsibilities:**
- Implements core functionality for `style.css`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `root` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 209. `/teacher/dashboard.html`

**Type:** HTML

**Role:** Component / file serving teacher functionality in the platform.

**Responsibilities:**
- Implements core functionality for `dashboard.html`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `teacher` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** YES

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** ACTIVE

---

### 210. `/tsconfig.json`

**Type:** JSON

**Role:** Component / file serving tsconfig.json functionality in the platform.

**Responsibilities:**
- Implements core functionality for `tsconfig.json`
- Handles data / presentation structure for its respective application module
- Supports platform operation in either Node.js runtime or PHP/MySQL backend

**Used by:** `root` application controllers, frontend pages, or build scripts

**Depends on:** System dependencies, runtime environment, or imported helper modules

**Data handled:** Reads/writes application state, user metadata, curriculum data, or assets

**Database interaction:** NO

**Authentication relevance:** NO

**Progress relevance:** NO

**Exam relevance:** NO

**Curriculum relevance:** NO

**Runtime status:** PARTIALLY ACTIVE (Next.js Boilerplate / Tooling)

---

## 5. Frontend Files

The platform features 20 HTML entry points categorized into Student Portal, Admin Portal, Teacher Portal, and Public/Auth Pages.

### Public & Auth Pages
- **`index.html`**: Root marketing landing page. Displays hero sections, course pathways, and features. Loads `js/session.js`, `js/components.js`, `js/theme.js`.
- **`login.html`**: Authentication sign-in form. Captures credentials, executes `POST /api/auth/login.php` via `js/session.js`, handles user redirection based on role (`student`, `teacher`, `admin`).
- **`signup.html`**: Student account registration form. Submits user details to `POST /api/auth/signup.php`, initializes new student session and gamification defaults.
- **`about.html`**: Static informational page introducing SPS Code Orbit curriculum philosophy and mission.
- **`courses.html`**: Public course directory listing available learning tracks and tracks preview. Loads `data/curriculum_index.js` and `js/session.js`.
- **`challenges.html`**: Interactive coding puzzle catalog for practice exercises.

### Student Portal (`/student/`)
- **`student/dashboard.html`**: Student dashboard home. Displays current streak, total XP, enrolled courses overview, recent activity, and next recommended lessons. Calls `GET /api/student/dashboard.php` and `GET /api/gamification/status.php`.
- **`student/courses.html`**: Student course catalog and active enrollments view. Displays enrolled vs available courses, enrollment toggles, and track filters. Calls `GET /api/courses/list.php` and `POST /api/courses/enroll.php`.
- **`student/course.html`**: Course details and chapter roadmap view. Displays chapter list, progress bars, locked/unlocked state, and exam links. Calls `GET /api/courses/detail.php`.
- **`student/chapter.html`**: Chapter view showing lesson cards and chapter completion state.
- **`student/lesson.html`**: Interactive lesson classroom. Renders dialogue feed, theory text, interactive code blocks, practice challenge widgets, and complete lesson button. Calls `GET /api/lessons/get.php` and `POST /api/lessons/complete.php`.
- **`student/exam.html`**: Chapter exam page. Renders chapter quiz questions, option selectors, timer, submission handler, score results modal, and chapter completion triggers. Calls `GET /api/exams/get.php` and `POST /api/exams/submit.php`.
- **`student/progress.html`**: Student academic progress & analytics dashboard. Displays overall course completion %, lesson statistics, and chapter badges. Calls `GET /api/student/progress.php`.
- **`student/profile.html`**: Student profile & settings view. Displays user metadata, academic group, grade/class assignment, streak calendar, and earned badges. Calls `GET /api/student/profile.php`.
- **`student/challenges.html`**: Practice puzzle interface for student challenge submissions.

### Admin Portal (`/admin/`)
- **`admin/dashboard.html`**: Administrator control panel. Displays total student count, active teacher count, course enrollments, system health, and system metrics. Calls `GET /api/admin/metrics.php`.
- **`admin/students.html`**: Student management table. Enables admins to search students, inspect profiles, update academic groups, and reset passwords. Calls `GET /api/admin/students.php`.
- **`admin/teachers.html`**: Teacher management view. Allows creating and assigning teacher accounts to academic classes. Calls `GET /api/admin/teachers.php`.
- **`admin/assessments.html`**: Platform-wide assessment & exam performance monitor. Displays exam completion rates and score averages across classes.

### Teacher Portal (`/teacher/`)
- **`teacher/dashboard.html`**: Teacher classroom management portal. Displays assigned classes, student rosters, project submissions awaiting grading, and class activity summaries. Calls `GET /api/teacher/students.php` and `GET /api/teacher/submissions.php`.

## 6. JavaScript Files

The platform contains 44 JavaScript files divided into runtime infrastructure, data models, and build scripts:

### Runtime Frontend & Server Core
- **`server.js`**: Primary Node.js HTTP runtime server. Intercepts `/api/*.php` endpoints, serves static assets, enforces cookie sessions (`orbit_session`), and proxies persistence to `data/db_store.js` (`data/db_store.json`).
- **`js/session.js`**: Core client authentication & session manager (`window.session`). Exposes `requireAuth()`, `login()`, `logout()`, `getUser()`, and `apiFetch()` with `credentials: "same-origin"` header handling.
- **`js/gamification.js`**: Client-side gamification engine. Calculates XP levels, daily streaks, level progression animations, and toast notifications for earned rewards.
- **`js/components.js`**: Reusable Web Component definitions (`Sidebar`, `Header`, `Footer`, `StatCard`, `ProgressBar`). Dynamically injects unified navigation UI across portal pages.
- **`js/code-runner.js`**: Client-side code execution sandbox. Runs JavaScript code in iframe / worker contexts and captures standard output/error streams for lesson practice blocks.
- **`js/theme.js`**: Theme switcher module managing light/dark mode preferences in `localStorage`.

### Data & Curriculum Models (`/data/`)
- **`data/db_store.js`**: Node.js file-backed database layer. Provides read/write operations for `data/db_store.json` (enrollments, lesson progress, user profiles, gamification, exam attempts).
- **`data/curriculum_index.js`**: Primary frontend curriculum registry (`window.CURRICULUM_INDEX`). Aggregates all course modules, resolves lesson IDs, tracks completion status, and calculates progress percentages.
- **`data/courses.js`**: Master course catalog array containing metadata, titles, descriptions, icons, grade levels, and chapter ordering.
- **`data/chapters.js`**: Master chapter array mapping chapter IDs to parent course IDs and lesson sequences.
- **`data/lessons.js`**: Core lesson definition index mapping lesson IDs to chapter containers.
- **`data/chapter_exams.js`**: Master exam definitions mapping chapter IDs to question sets, answer options, and correct option indices.
- **`data/*_curriculum.js`** (13 files): Track-specific curriculum definitions (e.g. `scratch_adventures_curriculum.js`, `python_foundations_curriculum.js`, `js_adventures_curriculum.js`, `frontend_builder_curriculum.js`). Provide granular lesson dialogue, blocks, and challenges.

### Build & Maintenance Utility Scripts (`/scripts/`)
- **`scripts/*.js`** & **`scripts/*.py`** (19 files): Build and migration utility scripts used to compile raw curriculum markdown/JSON into structured JavaScript arrays, seed files, and exam JSON exports (`scripts/export_exams_json.js`, `scripts/build_full_curriculum.py`, `scripts/generate_curriculum_sql.js`).

## 7. PHP Backend

The repository includes 65 PHP files implementing a complete backend architecture for a LAMP/LEMP server stack. In the Cloud Run environment, these endpoints are emulated/intercepted in `server.js`.

### Authentication APIs (`/api/auth/`)
- **`api/auth/login.php`**: Validates credentials against `profiles` table using `password_verify()`. On success, sets native PHP `$_SESSION["user_id"]` and `orbit_session` cookie, returning user metadata and CSRF token.
- **`api/auth/signup.php`**: Registers new student profiles in `profiles` and initializes `student_gamification` record.
- **`api/auth/me.php`**: Authenticates current session via cookie/header, returning current user profile, academic group, role, XP, and streak.
- **`api/auth/logout.php`**: Destroys active PHP session and clears authentication cookies.
- **`api/auth/bootstrap_admin.php`**: Utility script to seed initial administrator user account.

### Student & Progress APIs (`/api/student/`, `/api/lessons/`, `/api/courses/`)
- **`api/student/dashboard.php`**: Fetches active enrollments, course progress percentages, XP, streak, and recent lesson activity.
- **`api/student/progress.php`**: Aggregates comprehensive student progress report across all courses, chapters, and lessons.
- **`api/student/profile.php`**: Returns student profile metadata, academic class assignment, badges, and activity history.
- **`api/courses/list.php`**: Returns catalog of available courses and user enrollment status.
- **`api/courses/detail.php`**: Returns detailed course syllabus including chapters, lessons, lock status, and completion state.
- **`api/courses/enroll.php`**: Inserts course enrollment record in `course_enrollments` table.
- **`api/lessons/get.php`**: Fetches lesson content, theory text, code blocks, and practice questions.
- **`api/lessons/complete.php`**: Marks lesson as completed in `lesson_progress`, updates `chapter_progress` and `course_progress`, awards XP points, and updates streak.

### Exam APIs (`/api/exams/`)
- **`api/exams/get.php`**: Fetches chapter exam questions and option sets without exposing correct answer keys.
- **`api/exams/submit.php`**: Evaluates submitted exam answers against `question_answer_keys`, records attempt in `exam_attempts`, calculates score percentage, and if >= 70%, marks chapter as completed in `chapter_progress` and unlocks next chapter.

### Admin & Teacher APIs (`/api/admin/`, `/api/teacher/`)
- **`api/admin/metrics.php`**: Generates admin dashboard metrics (total students, active teachers, completion rates).
- **`api/admin/students.php`** & **`api/admin/get_students.php`**: Queries and updates student profiles, academic groups, and passwords.
- **`api/admin/teachers.php`** & **`api/admin/get_teachers.php`**: Queries and updates teacher account assignments.
- **`api/teacher/students.php`**: Returns student list and progress metrics for teacher assigned classes.
- **`api/teacher/submissions.php`** & **`api/teacher/grade_submission.php`**: Manages student project submissions and grading.

### Configuration, Middleware & Helpers
- **`config/config.php`**: Global PHP configuration, error reporting, base URLs, session options, timezone settings.
- **`config/database.php`**: PDO database connection manager connecting to MySQL database.
- **`middleware/auth.php`**: Authentication middleware verifying active session or bearer tokens.
- **`middleware/student.php`**, **`middleware/teacher.php`**, **`middleware/admin.php`**: Role-based access control (RBAC) authorization guards.
- **`middleware/csrf.php`**: CSRF token generation and validation middleware.
- **`includes/helpers.php`**, **`includes/response.php`**, **`includes/curriculum_helpers.php`**, **`includes/exam_questions.php`**: Utility libraries for standard JSON responses, input sanitization, and content helpers.

## 8. Database

The database schema is defined in `database/database.sql` and initialized via `database/seed.sql`, `database/seed_curriculum.sql`, `database/seed_curriculum.php`, and `database/seed_exams.php`.

### Database Table List (29 Tables Defined)

#### Table: `profiles`
- **Purpose**: User accounts & auth credentials
- **Primary Key**: `id (VARCHAR)`
- **Important Columns**: `username, email, password_hash, role, full_name`
- **Relationships & Usage**: Primary user table for students, teachers, admins. Used by auth and profile APIs.

#### Table: `academic_groups`
- **Purpose**: School academic groups/tiers
- **Primary Key**: `id (VARCHAR)`
- **Important Columns**: `name, code, description`
- **Relationships & Usage**: Defines Preparatory, Primary, Secondary tiers. Used by admin and profile APIs.

#### Table: `grades`
- **Purpose**: Grade levels within academic groups
- **Primary Key**: `id (VARCHAR)`
- **Important Columns**: `academic_group_id, name, level_order`
- **Relationships & Usage**: Organizes Prep 1-3, Primary 1-6, Secondary 1-3. FK to academic_groups.

#### Table: `classes`
- **Purpose**: Specific student classrooms
- **Primary Key**: `id (VARCHAR)`
- **Important Columns**: `grade_id, name, room_number`
- **Relationships & Usage**: Specific class sections (e.g. Prep 3-C). FK to grades.

#### Table: `teacher_classes`
- **Purpose**: Teacher classroom assignments
- **Primary Key**: `id (INT)`
- **Important Columns**: `teacher_id, class_id`
- **Relationships & Usage**: Junction table mapping teachers to classes. FKs to profiles, classes.

#### Table: `teacher_academic_groups`
- **Purpose**: Teacher academic group access
- **Primary Key**: `id (INT)`
- **Important Columns**: `teacher_id, academic_group_id`
- **Relationships & Usage**: Maps teachers to academic tiers. FKs to profiles, academic_groups.

#### Table: `courses`
- **Purpose**: Curriculum course catalog
- **Primary Key**: `id (VARCHAR)`
- **Important Columns**: `title, slug, description, academic_group_id, icon_url, total_chapters`
- **Relationships & Usage**: Master course catalog. FK to academic_groups. Used by course APIs.

#### Table: `course_class_assignments`
- **Purpose**: Class course availability
- **Primary Key**: `id (INT)`
- **Important Columns**: `course_id, class_id`
- **Relationships & Usage**: Assigns courses to specific classes. FKs to courses, classes.

#### Table: `course_enrollments`
- **Purpose**: Student course enrollments
- **Primary Key**: `id (INT)`
- **Important Columns**: `student_id, course_id, enrolled_at, status`
- **Relationships & Usage**: Tracks active student course enrollments. FKs to profiles, courses.

#### Table: `chapters`
- **Purpose**: Course chapters/modules
- **Primary Key**: `id (VARCHAR)`
- **Important Columns**: `course_id, title, chapter_number, description`
- **Relationships & Usage**: Module containers within courses. FK to courses. Used by chapter/course APIs.

#### Table: `lessons`
- **Purpose**: Individual coding lessons
- **Primary Key**: `id (VARCHAR)`
- **Important Columns**: `chapter_id, title, lesson_number, exp_reward`
- **Relationships & Usage**: Individual lesson content. FK to chapters. Used by lesson APIs.

#### Table: `lesson_blocks`
- **Purpose**: Lesson block components
- **Primary Key**: `id (VARCHAR)`
- **Important Columns**: `lesson_id, block_type, content, sorting_order`
- **Relationships & Usage**: Structured theory, dialogue, and code blocks within a lesson. FK to lessons.

#### Table: `questions`
- **Purpose**: Assessment & challenge questions
- **Primary Key**: `id (VARCHAR)`
- **Important Columns**: `lesson_id, chapter_id, question_text, question_type`
- **Relationships & Usage**: Question pool for lesson practice and chapter exams. FKs to lessons, chapters.

#### Table: `question_answer_keys`
- **Purpose**: Answer keys for auto-grading
- **Primary Key**: `id (VARCHAR)`
- **Important Columns**: `question_id, correct_answer, explanation`
- **Relationships & Usage**: Secure answer keys for multiple choice/code questions. FK to questions.

#### Table: `exams`
- **Purpose**: Chapter-end examinations
- **Primary Key**: `id (VARCHAR)`
- **Important Columns**: `chapter_id, title, passing_score, time_limit_minutes`
- **Relationships & Usage**: Chapter final exams. FK to chapters. Used by exam APIs.

#### Table: `exam_questions`
- **Purpose**: Exam question mapping
- **Primary Key**: `id (INT)`
- **Important Columns**: `exam_id, question_id, points, sorting_order`
- **Relationships & Usage**: Junction table mapping questions to exams. FKs to exams, questions.

#### Table: `exam_attempts`
- **Purpose**: Student exam submission logs
- **Primary Key**: `id (VARCHAR)`
- **Important Columns**: `student_id, exam_id, score_percentage, passed, attempt_number`
- **Relationships & Usage**: Records student exam scores and pass/fail results. FKs to profiles, exams.

#### Table: `answers`
- **Purpose**: Student individual question responses
- **Primary Key**: `id (VARCHAR)`
- **Important Columns**: `attempt_id, question_id, student_answer, is_correct`
- **Relationships & Usage**: Detailed answer logs per exam attempt. FKs to exam_attempts, questions.

#### Table: `lesson_progress`
- **Purpose**: Student lesson completion records
- **Primary Key**: `id (INT)`
- **Important Columns**: `student_id, lesson_id, status, completed_at`
- **Relationships & Usage**: Tracks individual lesson completion status. FKs to profiles, lessons.

#### Table: `chapter_progress`
- **Purpose**: Student chapter progress state
- **Primary Key**: `id (INT)`
- **Important Columns**: `student_id, chapter_id, status, completed_at, exam_passed`
- **Relationships & Usage**: Tracks chapter completion and exam unlock status. FKs to profiles, chapters.

#### Table: `course_progress`
- **Purpose**: Student overall course completion
- **Primary Key**: `id (INT)`
- **Important Columns**: `student_id, course_id, completed_lessons, progress_percentage`
- **Relationships & Usage**: Aggregates overall course completion percentage. FKs to profiles, courses.

#### Table: `user_progress`
- **Purpose**: Legacy user progress table
- **Primary Key**: `id (INT)`
- **Important Columns**: `user_id, lesson_id, course_id, status`
- **Relationships & Usage**: Legacy/fallback progress tracking table. FKs to profiles.

#### Table: `student_gamification`
- **Purpose**: XP, streak, and level tracking
- **Primary Key**: `student_id (VARCHAR)`
- **Important Columns**: `total_xp, current_level, current_streak, last_activity_date`
- **Relationships & Usage**: Gamification status per student. FK to profiles. Used by gamification APIs.

#### Table: `xp_events`
- **Purpose**: Audit log of earned XP
- **Primary Key**: `id (INT)`
- **Important Columns**: `student_id, xp_amount, event_type, reference_id`
- **Relationships & Usage**: Detailed audit log of XP rewards. FK to profiles.

#### Table: `achievements`
- **Purpose**: Platform badge catalog
- **Primary Key**: `id (VARCHAR)`
- **Important Columns**: `title, description, icon_url, req_type, req_value`
- **Relationships & Usage**: Badge and achievement definitions.

#### Table: `student_achievements`
- **Purpose**: Student earned badges
- **Primary Key**: `id (INT)`
- **Important Columns**: `student_id, achievement_id, unlocked_at`
- **Relationships & Usage**: Junction table of unlocked student badges. FKs to profiles, achievements.

#### Table: `assignments`
- **Purpose**: Homework & classroom assignments
- **Primary Key**: `id (VARCHAR)`
- **Important Columns**: `teacher_id, class_id, title, due_date`
- **Relationships & Usage**: Teacher created assignments. FKs to profiles, classes.

#### Table: `projects`
- **Purpose**: Student coding projects
- **Primary Key**: `id (VARCHAR)`
- **Important Columns**: `student_id, title, code_content, project_type`
- **Relationships & Usage**: Student coding projects and sandbox creations. FK to profiles.

#### Table: `project_submissions`
- **Purpose**: Graded project submissions
- **Primary Key**: `id (VARCHAR)`
- **Important Columns**: `project_id, assignment_id, grade, feedback`
- **Relationships & Usage**: Submissions graded by teachers. FKs to projects, assignments.

## 9. Authentication / Session Architecture

### Active Session Trace
1. **Signup**: `signup.html` -> `POST /api/auth/signup.php` -> Inserts record into `profiles` and default gamification record -> Automatically creates session.
2. **Login**: `login.html` -> `POST /api/auth/login.php` -> Verifies username/password -> Sets `orbit_session` HTTP cookie containing user ID (`student-alex-id` or `user_<username>`) and returns user JSON metadata.
3. **Session Hydration**: On page load, `js/session.js` calls `GET /api/auth/me.php` with `credentials: same-origin`. `server.js` parses cookie `orbit_session` (or `orbit_user_id` / `X-User-Id` header) and returns active profile details.
4. **Role Validation**: `window.session.requireAuth(["student"])` checks `user.role`. If unauthenticated or unauthorized, redirects to `/login.html`.
5. **Logout**: `window.session.logout()` -> `POST /api/auth/logout.php` -> Clears `orbit_session` cookie -> Redirects to `/login.html`.

### Coexisting & Legacy Auth Mechanisms Identified
- **HTTP Cookies**: `orbit_session`, `orbit_user_id`, `PHPSESSID` (Active primary mechanism).
- **HTTP Headers**: `X-User-Id` and `Authorization: Bearer <token>` (Supported as fallback in `server.js` and PHP middleware).
- **`localStorage` Fallback**: Legacy code in `js/session.js` supported saving `orbit_user` in `localStorage` when offline or in standalone static modes.

## 10. Course / Curriculum Architecture

### Content Pipeline & Trace
Course -> Chapters -> Lessons -> Lesson Blocks -> Questions -> Exams

### Content Sources Identified
1. **Active JS Data Bundles**: `data/curriculum_index.js` (`window.CURRICULUM_INDEX`), `data/courses.js`, `data/chapters.js`, `data/lessons.js`, and 13 track-specific curriculum files (e.g. `data/scratch_adventures_curriculum.js`).
2. **Runtime Server Store**: `data/db_store.js` / `data/db_store.json` used by `server.js` to serve `/api/courses/*` and `/api/lessons/*` endpoints.
3. **MySQL Schema & Seed Files**: `database/database.sql`, `database/seed_curriculum.sql`, `database/seed_curriculum.php` defining relational course content tables.
4. **JSON Data Exports**: `data/curriculum_export.json` and `sps_curriculum_complete_seed.json` generated by curriculum build scripts.

## 11. Progress Architecture

### Progress Tracking Pipeline
Student -> Enrollment -> Lesson Progress -> Chapter Progress -> Course Progress -> Exam Unlock

### Execution Logic
- **Enrollment**: `POST /api/courses/enroll.php` adds course ID to user enrollment list in `data/db_store.json` (or `course_enrollments` table).
- **Lesson Completion**: `POST /api/lessons/complete.php` records lesson ID in user progress array, increments `completed_lessons`, recalculates course completion percentage (`progress_percentage = (completed / total) * 100`), awards 50 XP, and increments daily streak.
- **Chapter Unlocks**: Passing chapter exam (>= 70%) marks chapter as completed and unlocks the next chapter sequence.

## 12. Exam Architecture

### Exam Lifecycle Trace
Chapter End -> Exam Page (`student/exam.html`) -> Fetch Questions (`GET /api/exams/get.php`) -> Submit Responses (`POST /api/exams/submit.php`) -> Automated Scoring -> Chapter Completion & Next Chapter Unlock

### Exam Sources & Execution
- **Definitions**: `data/chapter_exams.js` and `data/chapter_exams.json` provide question prompts, 4 multiple choice options, and answer indices.
- **Backend Validation**: `POST /api/exams/submit.php` evaluates answers against secret answer keys, records score in `exam_attempts`, awards bonus XP (100-150 XP), and sets `exam_passed = true`.

## 13. Gamification

- **XP System**: 50 XP awarded per completed lesson, 100-150 XP awarded per passed exam. Levels increment every 250 XP.
- **Daily Streaks**: Calculated by checking consecutive days of activity in `last_activity_date`.
- **Achievements / Badges**: Defined in `data/db_store.js` / `achievements` table (e.g. First Steps, Code Explorer, Python Master). Unlocked automatically upon reaching milestone thresholds.

## 14. Assets

The platform contains 32 image assets located in `assets/` and `src/assets/images/`:
- **Mascot Sprites**: `assets/cody/cody.png` (Cody Mascot), `assets/shady/shady.png` (Shady Mascot avatar).
- **Course Thumbnails**: `assets/courses/` (9 PNG icons: `scratch.png`, `web.png`, `ai.png`, `algo.png`, `design.png`, `game.png`, `gamedev.png`, `prog.png`, `robotics.png`).
- **Pathway Banners**: `assets/paths/` (`prep.png`, `primary.png`, `secondary.png`).
- **Character & Scene Banners**: `assets/images/` (`Astronaut_holding_coding.png`, `Astronaut_robot_holding_star.png`, `Green_alien_waving_in_UFO.png`, `Robot_waving_in_coding_banner.png`, `Yellow_star_character_smiling.png`, `Violet_planet_character_smiling.png`, `astronaut_hologram_scene.jpg`).
- **Source Image Backups**: `src/assets/images/` (9 timestamped JPEG/PNG backup assets).

## 15. Configuration

- **`config/config.php`**: Global PHP settings, base URLs, error logging, and session options.
- **`config/database.php`**: Contains PDO MySQL connection configuration settings (host, dbname, user, pass). *Contains sensitive configuration — values intentionally omitted.*
- **`package.json`**: Node.js project manifest defining applet dependencies (`express`, `cors`, `cookie-parser`, `next`, `react`, `lucide-react`, `tailwindcss`) and start scripts (`node server.js`).
- **`tsconfig.json`**: TypeScript compiler configuration.
- **`metadata.json`**: Application metadata manifest (`name`: "SPS Code Orbit", `requestFramePermissions`, `majorCapabilities`).
- **`.env.example`**: Environment variable declaration template.

## 16. Potential Legacy / Duplicate / Suspicious Files

The following files were identified during repository analysis as potential legacy, build cache, or duplicate data stores. **None of these files were deleted or modified.**

### DEFINITE Legacy / Cache Files
1. **`scripts/__pycache__/*.pyc`** (7 files): Compiled Python bytecode files from curriculum generation scripts.
2. **`sps_curriculum_complete_content.txt`**: Plain text backup export of curriculum content.
3. **`sps_curriculum_complete_seed.json`**: Standalone seed JSON file generated prior to `data/db_store.json`.
4. **`coursesData.js`** (Root): Duplicate/legacy copy of `data/coursesData.js`.

### POSSIBLE Unused / Duplicate Implementation Files
1. **`app/layout.tsx`**, **`app/globals.css`**, **`next.config.ts`**, **`next-env.d.ts`**, **`lib/utils.ts`**, **`hooks/use-mobile.ts`**: Skeleton Next.js App Router setup. The live platform operates on vanilla HTML/JS served via `server.js`.
2. **`data/curriculum_export.json`**: Static export JSON file superseded by `data/curriculum_index.js` and `data/db_store.json`.
3. **`database/seed_curriculum.php`** & **`database/seed_curriculum.sql`**: SQL/PHP seed scripts superseded by `data/db_store.js` runtime initialization.

## 17. File Dependency Map

### Login Flow
`login.html`
└── `js/session.js` (`window.session.login()`)
    └── `POST /api/auth/login.php`
        └── `server.js` (Node.js Interceptor) OR `middleware/auth.php` (PHP Stack)
            └── `data/db_store.js` (`db_store.json`) OR `config/database.php` (`profiles` table)

### Course Overview Flow
`student/course.html`
└── `js/session.js` (`window.session.requireAuth()`)
└── `data/curriculum_index.js` (`window.CURRICULUM_INDEX`)
└── `GET /api/courses/detail.php?id=<course_id>`
    └── `server.js` -> `data/db_store.js` (`data/db_store.json`)

### Lesson Classroom Flow
`student/lesson.html`
└── `js/session.js`
└── `js/code-runner.js` (Practice code runner)
└── `data/curriculum_index.js`
└── `GET /api/lessons/get.php?id=<lesson_id>`
└── `POST /api/lessons/complete.php`
    └── `server.js` -> `data/db_store.js` (`saveUserProgress()`)

### Exam Flow
`student/exam.html`
└── `js/session.js`
└── `data/chapter_exams.js`
└── `GET /api/exams/get.php?chapter_id=<chapter_id>`
└── `POST /api/exams/submit.php`
    └── `server.js` -> `data/db_store.js` (`saveExamAttempt()`)

## 18. Data Flow Map

### Authentication Data Flow
`User Form Input` -> `js/session.js` -> `POST /api/auth/login.php` -> `server.js` validates credentials -> Sets `Set-Cookie: orbit_session=<id>` -> Returns User JSON -> `js/session.js` stores user in memory -> Page Redirect

### Course & Lesson Progress Data Flow
`Student clicks Complete Lesson` -> `student/lesson.html` -> `POST /api/lessons/complete.php` -> `server.js` -> `dbStore.saveUserProgress()` updates `data/db_store.json` (adds lesson ID, increments completion %, awards 50 XP) -> Returns updated stats -> `js/gamification.js` triggers level-up toast -> UI updates button to Completed.

### Exam Scoring Data Flow
`Student submits quiz choices` -> `student/exam.html` -> `POST /api/exams/submit.php` -> `server.js` compares answers against `chapter_exams.js` -> Calculates score % -> Records attempt in `data/db_store.json` -> If score >= 70%, marks chapter complete and unlocks next chapter -> Returns score report modal to student.

## 19. Potential Architectural Conflicts

1. **Dual Server Runtimes (Node.js vs PHP)**:
   - *Conflict*: The repo contains 65 native PHP files expecting a LAMP/LEMP stack with PDO MySQL. However, Cloud Run executes `server.js` (Node.js), which intercepts `/api/*.php` paths and serves them via JavaScript logic.
   - *Evidence*: `server.js` imports `data/db_store.js` and contains explicit `pathname.includes(/api/auth/login.php)` handlers.

2. **Dual Data Persistence Engines (JSON Store vs MySQL Database)**:
   - *Conflict*: `database/database.sql` defines a 29-table relational database schema. In contrast, `server.js` reads and writes state to `data/db_store.json`.
   - *Evidence*: `data/db_store.js` contains `readStore()` and `writeStore()` reading/writing `data/db_store.json`.

3. **Multiple Curriculum Data Sources**:
   - *Conflict*: Curriculum content is defined across static JS files (`data/curriculum_index.js`), JSON files (`data/curriculum_export.json`), MySQL tables (`lessons`, `lesson_blocks`), and Python/JS build scripts.
   - *Evidence*: `student/lesson.html` loads 13 separate curriculum scripts (`/data/*_curriculum.js`).

## 20. Final Architecture Summary — What Actually Exists

### 10 Core Architectural Pillars
1. **Frontend**: Static HTML pages styled with Tailwind CSS v4 and custom dark/light theme variables. Custom web components (`js/components.js`) provide unified navigation headers, sidebars, and stat cards.
2. **Runtime Server**: Node.js HTTP web server (`server.js`) running on port 3000 in Cloud Run.
3. **Backend Middleware**: Express/HTTP route interceptors in `server.js` capturing `/api/*.php` requests.
4. **Active Persistence**: Single file JSON database store (`data/db_store.json`) managed by `data/db_store.js`.
5. **Source DB Schema**: 29-table MySQL database structure defined in `database/database.sql`.
6. **Authentication**: Cookie-based session authentication (`orbit_session` cookie) validated on every API request.
7. **Curriculum Engine**: Monolithic JavaScript index (`data/curriculum_index.js`) aggregating 13 track curriculum definitions.
8. **Progress Engine**: Per-student progress mapping tracking completed lesson IDs, chapter unlocks, and course completion percentages in `data/db_store.json`.
9. **Exam Engine**: Client-rendered quiz interface in `student/exam.html` verified server-side by `POST /api/exams/submit.php`.
10. **Gamification**: Real-time XP, level, daily streak, and badge system integrated into API response payloads.

### 15 Important Findings Before Making Future Changes
1. **Zero Files Modified in this Run**: This inventory task operated in strict read-only mode; no source code or database files were touched.
2. **Node.js is the Active Entry Point**: The platform runs via `node server.js` specified in `package.json`.
3. **PHP Files are Source Declarations**: The 65 PHP files in `/api/` document the intended server architecture, but live API calls are intercepted by Node.js.
4. **JSON Store is Active State**: `data/db_store.json` persists enrollments, completed lessons, exam attempts, and XP for active sessions.
5. **Session Cookies are Required**: Authentication relies on `credentials: "same-origin"` cookies (`orbit_session`).
6. **Default Test Student ID**: The default seed student is `student-alex-id` ("Alex Rivera").
7. **Passing Exam Threshold is 70%**: Scoring 70% or higher on chapter exams unlocks the next chapter.
8. **Lesson Completion Yields 50 XP**: Every completed lesson awards 50 XP and updates daily streaks.
9. **Next.js Scaffold is Inactive**: Next.js App Router files in `app/` exist as scaffolding but do not serve frontend pages.
10. **Curriculum Scripts are Local Builders**: Python and JS files in `scripts/` are offline build tools used to generate curriculum data bundles.
11. **`db_store.js` Auto-Initializes**: New users logging in automatically receive a full set of default course enrollments in `db_store.json`.
12. **All 29 Database Tables are Schema-Defined**: `database/database.sql` holds a complete relational schema ready for MySQL deployment.
13. **Multiple Fallback Paths**: `server.js` supports fallback headers (`X-User-Id`, `Authorization: Bearer`) alongside cookies.
14. **Asset Consistency**: All image assets reside in `assets/` and `src/assets/images/`.
15. **Verified Integrity**: All 210 files and 38 subdirectories are indexed and accounted for.

