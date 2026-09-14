-- SPS Code Orbit MySQL Database Schema
-- Compatible with MySQL 8.x

SET FOREIGN_KEY_CHECKS = 0;

-- 1. academic_groups
CREATE TABLE IF NOT EXISTS academic_groups (
    id CHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. grades
CREATE TABLE IF NOT EXISTS grades (
    id CHAR(36) PRIMARY KEY,
    academic_group_id CHAR(36) NOT NULL,
    name VARCHAR(255) NOT NULL,
    level INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (academic_group_id) REFERENCES academic_groups(id) ON DELETE CASCADE
);

-- 3. classes
CREATE TABLE IF NOT EXISTS classes (
    id CHAR(36) PRIMARY KEY,
    grade_id CHAR(36) NOT NULL,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (grade_id) REFERENCES grades(id) ON DELETE CASCADE
);

-- 5. profiles (User accounts)
CREATE TABLE IF NOT EXISTS profiles (
    id CHAR(36) PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NULL,
    role ENUM('student', 'teacher', 'admin') NOT NULL DEFAULT 'student',
    is_active TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1=active can login, 0=deactivated by admin',
    class_id CHAR(36) NULL,
    avatar_url VARCHAR(1024),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE SET NULL
);

-- 4. teacher_classes
CREATE TABLE IF NOT EXISTS teacher_classes (
    id CHAR(36) PRIMARY KEY,
    teacher_id CHAR(36) NOT NULL,
    class_id CHAR(36) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (teacher_id) REFERENCES profiles(id) ON DELETE CASCADE,
    FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE,
    UNIQUE KEY uk_teacher_class (teacher_id, class_id)
);

-- 4b. teacher_academic_groups
CREATE TABLE IF NOT EXISTS teacher_academic_groups (
    id CHAR(36) PRIMARY KEY,
    teacher_id CHAR(36) NOT NULL,
    academic_group_id CHAR(36) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (teacher_id) REFERENCES profiles(id) ON DELETE CASCADE,
    FOREIGN KEY (academic_group_id) REFERENCES academic_groups(id) ON DELETE CASCADE,
    UNIQUE KEY uk_teacher_academic_group (teacher_id, academic_group_id)
);

-- 4c. teacher_student_assignments (explicit individual student assignments)
CREATE TABLE IF NOT EXISTS teacher_student_assignments (
    id CHAR(36) PRIMARY KEY,
    teacher_id CHAR(36) NOT NULL,
    student_id CHAR(36) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (teacher_id) REFERENCES profiles(id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES profiles(id) ON DELETE CASCADE,
    UNIQUE KEY uk_teacher_student (teacher_id, student_id)
);

-- 6. courses
CREATE TABLE IF NOT EXISTS courses (
    id CHAR(36) PRIMARY KEY,
    academic_group_id CHAR(36) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    image_url VARCHAR(1024),
    accent_color VARCHAR(50),
    is_published TINYINT(1) DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (academic_group_id) REFERENCES academic_groups(id) ON DELETE CASCADE
);

-- 7. course_class_assignments
CREATE TABLE IF NOT EXISTS course_class_assignments (
    id CHAR(36) PRIMARY KEY,
    course_id CHAR(36) NOT NULL,
    class_id CHAR(36) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE,
    UNIQUE KEY uk_course_class (course_id, class_id)
);

-- 8. course_enrollments
CREATE TABLE IF NOT EXISTS course_enrollments (
    id CHAR(36) PRIMARY KEY,
    course_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES profiles(id) ON DELETE CASCADE,
    UNIQUE KEY uk_course_enrollment (course_id, user_id)
);

-- 9. chapters
CREATE TABLE IF NOT EXISTS chapters (
    id CHAR(36) PRIMARY KEY,
    course_id CHAR(36) NOT NULL,
    slug VARCHAR(255) NOT NULL,
    chapter_number INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    icon_symbol VARCHAR(50),
    xp_reward INT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    UNIQUE KEY uk_chapter_slug (course_id, slug)
);

-- 10. lessons
CREATE TABLE IF NOT EXISTS lessons (
    id CHAR(36) PRIMARY KEY,
    chapter_id CHAR(36) NOT NULL,
    slug VARCHAR(255) NOT NULL,
    lesson_number INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    duration_minutes INT DEFAULT 0,
    xp_reward INT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (chapter_id) REFERENCES chapters(id) ON DELETE CASCADE,
    UNIQUE KEY uk_lesson_slug (chapter_id, slug)
);

-- 11. lesson_blocks
CREATE TABLE IF NOT EXISTS lesson_blocks (
    id CHAR(36) PRIMARY KEY,
    lesson_id CHAR(36) NOT NULL,
    block_type VARCHAR(50) NOT NULL,
    order_index INT NOT NULL,
    content_json JSON NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE
);

-- 12. questions
CREATE TABLE IF NOT EXISTS questions (
    id CHAR(36) PRIMARY KEY,
    question_text TEXT NOT NULL,
    question_type VARCHAR(50) NOT NULL,
    options_json JSON,
    points INT DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 13. question_answer_keys
CREATE TABLE IF NOT EXISTS question_answer_keys (
    id CHAR(36) PRIMARY KEY,
    question_id CHAR(36) NOT NULL,
    correct_answer JSON NOT NULL,
    explanation TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
);

-- 14. exams
CREATE TABLE IF NOT EXISTS exams (
    id CHAR(36) PRIMARY KEY,
    chapter_id CHAR(36) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    passing_score_percent INT DEFAULT 70,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (chapter_id) REFERENCES chapters(id) ON DELETE CASCADE
);

-- 15. exam_questions
CREATE TABLE IF NOT EXISTS exam_questions (
    id CHAR(36) PRIMARY KEY,
    exam_id CHAR(36) NOT NULL,
    question_id CHAR(36) NOT NULL,
    order_index INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE,
    UNIQUE KEY uk_exam_question (exam_id, question_id)
);

-- 16. exam_attempts
CREATE TABLE IF NOT EXISTS exam_attempts (
    id CHAR(36) PRIMARY KEY,
    user_id CHAR(36) NOT NULL,
    exam_id CHAR(36) NOT NULL,
    score INT,
    passed TINYINT(1),
    started_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    completed_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES profiles(id) ON DELETE CASCADE,
    FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE
);

-- 16b. exam_attempts_archive
CREATE TABLE IF NOT EXISTS exam_attempts_archive (
    id CHAR(36) PRIMARY KEY,
    user_id CHAR(36) NOT NULL,
    exam_id CHAR(36) NOT NULL,
    score INT,
    passed TINYINT(1),
    started_at DATETIME,
    completed_at DATETIME,
    archived_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 17. answers
CREATE TABLE IF NOT EXISTS answers (
    id CHAR(36) PRIMARY KEY,
    exam_attempt_id CHAR(36) NOT NULL,
    question_id CHAR(36) NOT NULL,
    submitted_answer JSON,
    is_correct TINYINT(1),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (exam_attempt_id) REFERENCES exam_attempts(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
);

-- 18. lesson_progress
CREATE TABLE IF NOT EXISTS lesson_progress (
    id CHAR(36) PRIMARY KEY,
    user_id CHAR(36) NOT NULL,
    lesson_id CHAR(36) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'not_started',
    started_at DATETIME,
    completed_at DATETIME,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES profiles(id) ON DELETE CASCADE,
    FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
    UNIQUE KEY uk_lesson_progress (user_id, lesson_id)
);

-- 19. chapter_progress
CREATE TABLE IF NOT EXISTS chapter_progress (
    id CHAR(36) PRIMARY KEY,
    user_id CHAR(36) NOT NULL,
    chapter_id CHAR(36) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'not_started',
    started_at DATETIME,
    completed_at DATETIME,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES profiles(id) ON DELETE CASCADE,
    FOREIGN KEY (chapter_id) REFERENCES chapters(id) ON DELETE CASCADE,
    UNIQUE KEY uk_chapter_progress (user_id, chapter_id)
);

-- 20. course_progress
CREATE TABLE IF NOT EXISTS course_progress (
    id CHAR(36) PRIMARY KEY,
    user_id CHAR(36) NOT NULL,
    course_id CHAR(36) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'not_started',
    started_at DATETIME,
    completed_at DATETIME,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES profiles(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    UNIQUE KEY uk_course_progress (user_id, course_id)
);

-- 20b. user_progress (Aggregated Course Progress model)
CREATE TABLE IF NOT EXISTS user_progress (
    id CHAR(36) PRIMARY KEY,
    user_id CHAR(36) NOT NULL,
    course_id CHAR(36) NOT NULL,
    completed_lessons JSON NOT NULL,
    percentage DECIMAL(5,2) DEFAULT 0.00,
    last_accessed DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES profiles(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    UNIQUE KEY uk_user_course_progress (user_id, course_id)
);

-- 21. student_gamification
CREATE TABLE IF NOT EXISTS student_gamification (
    id CHAR(36) PRIMARY KEY,
    user_id CHAR(36) NOT NULL UNIQUE,
    total_xp INT DEFAULT 0,
    current_streak INT DEFAULT 0,
    longest_streak INT DEFAULT 0,
    last_activity_date DATE,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES profiles(id) ON DELETE CASCADE
);

-- 22. xp_events
CREATE TABLE IF NOT EXISTS xp_events (
    id CHAR(36) PRIMARY KEY,
    user_id CHAR(36) NOT NULL,
    amount INT NOT NULL,
    source_type VARCHAR(100) NOT NULL,
    source_id CHAR(36),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES profiles(id) ON DELETE CASCADE
);

-- 23. achievements
CREATE TABLE IF NOT EXISTS achievements (
    id CHAR(36) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    icon_url VARCHAR(1024),
    xp_reward INT DEFAULT 0,
    criteria_json JSON,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 24. student_achievements
CREATE TABLE IF NOT EXISTS student_achievements (
    id CHAR(36) PRIMARY KEY,
    user_id CHAR(36) NOT NULL,
    achievement_id CHAR(36) NOT NULL,
    earned_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES profiles(id) ON DELETE CASCADE,
    FOREIGN KEY (achievement_id) REFERENCES achievements(id) ON DELETE CASCADE,
    UNIQUE KEY uk_student_achievement (user_id, achievement_id)
);

-- 25. assignments
CREATE TABLE IF NOT EXISTS assignments (
    id CHAR(36) PRIMARY KEY,
    teacher_id CHAR(36) NOT NULL,
    class_id CHAR(36) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    target_type VARCHAR(50),
    target_id CHAR(36),
    due_date DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (teacher_id) REFERENCES profiles(id) ON DELETE CASCADE,
    FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE
);

-- 26. projects
CREATE TABLE IF NOT EXISTS projects (
    id CHAR(36) PRIMARY KEY,
    course_id CHAR(36) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    instructions TEXT,
    xp_reward INT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

-- 27. project_submissions
CREATE TABLE IF NOT EXISTS project_submissions (
    id CHAR(36) PRIMARY KEY,
    user_id CHAR(36) NOT NULL,
    project_id CHAR(36) NOT NULL,
    status VARCHAR(50) DEFAULT 'submitted',
    content_json JSON,
    feedback TEXT,
    grade INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES profiles(id) ON DELETE CASCADE,
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
);

SET FOREIGN_KEY_CHECKS = 1;
