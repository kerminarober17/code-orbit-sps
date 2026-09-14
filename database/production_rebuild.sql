-- ============================================================================
-- SPS Code Orbit — PRODUCTION DATABASE REBUILD (authoritative single file)
-- Browser → PHP → MySQL
-- options_json: {"options":["A","B","C","D"]} only
-- L2 exams: passing_score_percent = 60
-- ============================================================================
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `student_achievements`;
DROP TABLE IF EXISTS `achievements`;
DROP TABLE IF EXISTS `xp_events`;
DROP TABLE IF EXISTS `student_gamification`;
DROP TABLE IF EXISTS `user_progress`;
DROP TABLE IF EXISTS `course_progress`;
DROP TABLE IF EXISTS `chapter_progress`;
DROP TABLE IF EXISTS `lesson_progress`;
DROP TABLE IF EXISTS `answers`;
DROP TABLE IF EXISTS `exam_attempts_archive`;
DROP TABLE IF EXISTS `exam_attempts`;
DROP TABLE IF EXISTS `exam_questions`;
DROP TABLE IF EXISTS `question_answer_keys`;
DROP TABLE IF EXISTS `questions`;
DROP TABLE IF EXISTS `exams`;
DROP TABLE IF EXISTS `project_submissions`;
DROP TABLE IF EXISTS `projects`;
DROP TABLE IF EXISTS `assignments`;
DROP TABLE IF EXISTS `lesson_blocks`;
DROP TABLE IF EXISTS `lessons`;
DROP TABLE IF EXISTS `chapters`;
DROP TABLE IF EXISTS `course_enrollments`;
DROP TABLE IF EXISTS `course_class_assignments`;
DROP TABLE IF EXISTS `courses`;
DROP TABLE IF EXISTS `teacher_academic_groups`;
DROP TABLE IF EXISTS `teacher_classes`;
DROP TABLE IF EXISTS `profiles`;
DROP TABLE IF EXISTS `classes`;
DROP TABLE IF EXISTS `grades`;
DROP TABLE IF EXISTS `academic_groups`;
SET FOREIGN_KEY_CHECKS = 1;

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


-- SPS Code Orbit Seed Data

-- UUIDs for fixed seed records
SET @ag_primary_3_4 = UUID();
SET @ag_primary_5_6 = UUID();
SET @ag_preparatory = UUID();
SET @ag_secondary = UUID();

-- Academic Groups
INSERT INTO academic_groups (id, name, description) VALUES
(@ag_primary_3_4, 'Primary 3-4', 'Basic programming and computational thinking for ages 8-10'),
(@ag_primary_5_6, 'Primary 5-6', 'Intermediate logic and visual programming for ages 10-12'),
(@ag_preparatory, 'Preparatory', 'Text-based programming and problem solving for ages 12-15'),
(@ag_secondary, 'Secondary', 'Advanced algorithms and real-world projects for ages 15-18');

-- Grades
SET @grade_3 = UUID();
SET @grade_4 = UUID();
SET @grade_5 = UUID();
SET @grade_6 = UUID();
SET @grade_prep_1 = UUID();
SET @grade_sec_1 = UUID();

INSERT INTO grades (id, academic_group_id, name, level) VALUES
(@grade_3, @ag_primary_3_4, 'Primary 3', 3),
(@grade_4, @ag_primary_3_4, 'Primary 4', 4),
(@grade_5, @ag_primary_5_6, 'Primary 5', 5),
(@grade_6, @ag_primary_5_6, 'Primary 6', 6),
(@grade_prep_1, @ag_preparatory, 'Prep 1', 7),
(@grade_sec_1, @ag_secondary, 'Secondary 1', 10);

-- Classes
SET @class_3A = UUID();
SET @class_4B = UUID();
SET @class_5C = UUID();
SET @class_6A = UUID();
SET @class_prep_1A = UUID();
SET @class_sec_1A = UUID();

INSERT INTO classes (id, grade_id, name) VALUES
(@class_3A, @grade_3, 'Class 3A - Alpha'),
(@class_4B, @grade_4, 'Class 4B - Beta'),
(@class_5C, @grade_5, 'Class 5C - Gamma'),
(@class_6A, @grade_6, 'Class Primary 6 - A'),
(@class_prep_1A, @grade_prep_1, 'Class Prep 1 - A'),
(@class_sec_1A, @grade_sec_1, 'Class Secondary 1 - A');

-- Achievements
INSERT INTO achievements (id, title, description, xp_reward, icon_url) VALUES
(UUID(), 'First Steps', 'Complete your very first lesson.', 50, '/assets/achievements/first-steps.png'),
(UUID(), 'Fast Learner', 'Complete 3 lessons in a single day.', 100, '/assets/achievements/fast-learner.png'),
(UUID(), 'Bug Squasher', 'Successfully pass a debugging quiz.', 75, '/assets/achievements/bug-squasher.png');

-- Initial Users (Password: admin123, teacher123, student123)
-- All hashed with password_hash(..., PASSWORD_DEFAULT)
INSERT INTO profiles (id, username, password_hash, full_name, role) VALUES
(UUID(), 'admin', '$2y$10$LkZ5ZQ5hQt1MgJqnANAo7ebq7ym2we4lkHrzZ3K87I5/ky7r7XvMe', 'System Administrator', 'admin')
ON DUPLICATE KEY UPDATE password_hash = VALUES(password_hash);



-- SPS Code Orbit 2-Course Production Curriculum SQL Dump
-- Authoritative production curriculum (Programming Foundations + Python Foundations)

SET FOREIGN_KEY_CHECKS = 0;

-- Ensure standard Academic Groups exist
INSERT INTO academic_groups (id, name, description) VALUES
('ag-prep', 'Preparatory', 'Interactive coding and web adventures for preparatory students'),
('ag-p34', 'Primary 3 & 4', 'Visual programming logic and computational thinking'),
('ag-p56', 'Primary 5 & 6', 'Creative coding and interactive Python adventures'),
('ag-sec', 'Secondary', 'Advanced computer science and full-stack software development')
ON DUPLICATE KEY UPDATE name = VALUES(name), description = VALUES(description);

SET FOREIGN_KEY_CHECKS = 1;

-- Course: Programming Foundations — Start Here
INSERT INTO courses (id, academic_group_id, title, slug, description, image_url, accent_color, is_published, created_at, updated_at) VALUES (
  'course-programming-foundations',
  'ag-prep',
  'Programming Foundations — Start Here',
  'programming-foundations',
  'The complete foundational course: discover what programming truly is, how computers and the internet work, and master algorithmic thinking before writing code in any language.',
  '/assets/courses/prog.png',
  '#70D6FF',
  1, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), description = VALUES(description), is_published = 1, image_url = VALUES(image_url), accent_color = VALUES(accent_color);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pf-01',
  'course-programming-foundations',
  'chap-pf-01-technology-around-us',
  1,
  'Chapter 1: Technology All Around Us',
  'Technology isn\'t magic — it is smart tools built with code. Discover hardware vs. software, the Input/Process/Output cycle, and the binary language of 0s and 1s.',
  '💡',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-1-1',
  'chap-pf-01',
  'pf-1-1-technology-in-our-lives',
  1,
  '1.1: Technology in Everyday Life',
  12,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-1-1',
  'lesson-pf-1-1',
  'dialogue',
  1,
  '{"shady":"I woke up to my phone\'s alarm, took the elevator down, waited at the pedestrian traffic light, and hopped on the bus. Just an ordinary morning! 😅","cody":"Look closely, Shady! Every single moment of your morning was powered by technology running code written by programmers!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-1-2',
  'lesson-pf-1-1',
  'dialogue',
  2,
  '{"shady":"Wait, the elevator and traffic lights are programmed with code too?!","cody":"Absolutely! Every modern device follows instructions written by software engineers to know when to open doors, change light signals, and navigate routes. Code is everywhere around you!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-1-3',
  'lesson-pf-1-1',
  'text',
  3,
  '{"title":"What is Technology Really?","body":"Technology is any tool, system, or machine created by humans to solve problems and make daily life easier.<br><br>Most modern technology runs on <strong>Software</strong> — precise programs written by programmers:<br>• 📱 <strong>Smartphones:</strong> Run thousands of complex apps seamlessly.<br>• 🚦 <strong>Traffic Lights:</strong> Smart algorithms adjust timings to prevent traffic jams.<br>• 🏧 <strong>ATM Machines:</strong> Secure banking code verifies your account and dispenses cash in seconds.<br>• 🎮 <strong>Video Games:</strong> Millions of lines of code calculate physics, render 3D graphics, and create immersive worlds.<br>• 🏥 <strong>Hospital Equipment:</strong> Life-saving monitors track patient vitals around the clock."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-1-4',
  'lesson-pf-1-1',
  'quick_check',
  4,
  '{"title":"Quick Check: Identify Technology","question":"Which of the following devices relies on a computer program (software) to function?","options":{"A":"A standard wooden pencil","B":"A digital microwave oven with preset timers","C":"A ceramic coffee mug","D":"A metal paperclip"},"correct":"B","explanation":"A digital microwave uses an embedded microchip running software routines to read inputs, manage cook times, and control power."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-1-5',
  'lesson-pf-1-1',
  'text',
  5,
  '{"title":"Hands-on Exercise: Classify Your World","body":"Think about items around your room right now and classify them:<br>1. A tree branch outside your window → Natural object, not technology.<br>2. A regular wooden ruler → Mechanical measuring tool without code.<br>3. A smart thermostat that adjusts room temperature automatically → Digital technology powered by code.<br>4. Wireless Bluetooth headphones → Advanced technology running communication protocols."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-1-2',
  'chap-pf-01',
  'pf-1-2-hardware-vs-software',
  2,
  '1.2: Hardware vs. Software — What\'s the Difference?',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-2-1',
  'lesson-pf-1-2',
  'dialogue',
  1,
  '{"shady":"Cody! My computer suddenly froze and showed a strange error message! Did something physically break inside?","cody":"First step, Shady: did a wire disconnect or did a physical piece snap off?"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-2-2',
  'lesson-pf-1-2',
  'dialogue',
  2,
  '{"shady":"No, the computer itself looks totally fine. Just the app crashed and closed!","cody":"Aha! Physical damage = Hardware issue. Application crashes and error dialogs = Software issue. They work together as one team!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-2-3',
  'lesson-pf-1-2',
  'text',
  3,
  '{"title":"Crucial Comparison: Hardware vs. Software","body":"<strong>1. Hardware (The Physical Machine):</strong><br>Every tangible component you can physically touch with your hands:<br>• The Screen/Monitor, Keyboard, and Mouse.<br>• Central Processing Unit (CPU): The \'brain\' that executes billions of calculations per second.<br>• RAM (Random Access Memory): Super-fast temporary workspace for open apps.<br>• Storage Drive (SSD / HDD): Permanent storage for files, photos, and operating systems.<br><br><strong>2. Software (The Digital Instructions):</strong><br>The programs and code that bring hardware to life:<br>• Operating Systems (Windows, macOS, iOS, Android).<br>• Applications: Web browsers, WhatsApp, Photoshop, VS Code.<br>• Video games and graphical rendering engines.<br><br><strong>The Golden Rule:</strong><br><em>Hardware without Software = A lifeless box of metal and silicon.<br>Software without Hardware = Ideas and instructions with no machine to execute them!</em>"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-2-4',
  'lesson-pf-1-2',
  'quick_check',
  4,
  '{"title":"Quick Check: Hardware or Software?","question":"If WhatsApp crashes due to a coding bug in an update, this is an issue with:","options":{"A":"Hardware","B":"Software","C":"The phone\'s glass screen","D":"The charging cable"},"correct":"B","explanation":"WhatsApp is a software application. An application crash caused by a code bug is purely a software issue."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-1-3',
  'chap-pf-01',
  'pf-1-3-input-process-output',
  3,
  '1.3: What Does a Computer Actually Do? (Input → Process → Output)',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-3-1',
  'lesson-pf-1-3',
  'dialogue',
  1,
  '{"shady":"I typed a query into Google and hit Enter... and in less than half a second, millions of results appeared! What just happened inside the computer?","cody":"Great question, Shady! Every computing operation on planet Earth passes through three fundamental stations: Input → Process → Output!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-3-2',
  'lesson-pf-1-3',
  'text',
  2,
  '{"title":"The Universal Computing Cycle: Input → Process → Output","body":"<strong>1. Input (Feeding Data In):</strong><br>Information and commands you provide to the computer via keyboard, mouse, touchscreen, microphone, or camera.<br><br><strong>2. Process (Computing & Thinking):</strong><br>The Central Processing Unit (CPU) performs operations step-by-step according to software rules: comparing, calculating, searching, sorting, and transforming data.<br><br><strong>3. Output (Delivering Results):</strong><br>The final outcome displayed to you: graphics on a screen, sound through speakers, or text printed on paper.<br><br><strong>Real-World Examples:</strong><br>• <strong>Calculator:</strong> You press 5 + 3 (Input) → CPU adds them together (Process) → Screen displays 8 (Output).<br>• <strong>Racing Game:</strong> You tap the right arrow key (Input) → Game engine calculates physics and steering angle (Process) → Car turns smoothly on the track (Output)."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-3-3',
  'lesson-pf-1-3',
  'quick_check',
  3,
  '{"title":"Quick Check: IPO Cycle","question":"In a gaming console: pressing the jump button is ______, while seeing your character leap on screen is ______:","options":{"A":"Output / Input","B":"Input / Output","C":"Process / Input","D":"Output / Process"},"correct":"B","explanation":"Pressing the button inputs a command into the system, and the visual animation displayed on screen is the output."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-1-4',
  'chap-pf-01',
  'pf-1-4-how-computers-think-binary',
  4,
  '1.4: How Computers Think (Binary: 0 and 1)',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-4-1',
  'lesson-pf-1-4',
  'dialogue',
  1,
  '{"shady":"Cody, if computers are so smart, why can\'t I just tell it in plain English: \'Calculate my exam grades\' without any code?","cody":"Because deep down inside, a computer is an electronic machine! It doesn\'t understand letters or words — it only understands tiny electrical signals: ON (1) and OFF (0)!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-4-2',
  'lesson-pf-1-4',
  'text',
  2,
  '{"title":"The Machine\'s True Language: The Binary System","body":"A computer\'s processor is built with billions of microscopic electrical switches called <strong>transistors</strong>.<br>Each transistor can only be in one of two states:<br>• Switch ON / Current flowing = <strong>1</strong><br>• Switch OFF / No current = <strong>0</strong><br><br><strong>How Does Everything Turn Into 0s and 1s?</strong><br>• The letter \'A\' is represented in standard ASCII binary as: <code>01000001</code><br>• The number 7 is represented in binary as: <code>00000111</code><br>• Colors, images, audio, and 4K videos are all broken down into vast sequences of 0s and 1s.<br><br><strong>Why Do We Need Programming Languages?</strong><br>Instead of manually typing thousands of binary digits like <code>01110000 01110010 01101001 01101110 01110100</code>, we write an elegant Python command: <code>print(\\"Hello\\")</code>. The programming language translates our command into binary in a fraction of a millisecond!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-1-4-3',
  'lesson-pf-1-4',
  'quick_check',
  3,
  '{"title":"Quick Check: Binary System","question":"In digital circuits, the \'ON\' state represents the digit ____, and the \'OFF\' state represents the digit ____:","options":{"A":"0 then 1","B":"1 then 0","C":"2 then 1","D":"1 then 2"},"correct":"B","explanation":"In binary logic, electricity flowing (ON) is represented by 1, and electricity stopped (OFF) is represented by 0."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pf-02',
  'course-programming-foundations',
  'chap-pf-02-what-is-a-program',
  2,
  'Chapter 2: What is a Program?',
  'A program is a precise step-by-step recipe. Master sequential execution (Sequence), decision-making with conditions (IF/ELSE), and repetition with loops (Loops).',
  '📜',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-2-1',
  'chap-pf-02',
  'pf-2-1-programs-like-recipes',
  1,
  '2.1: Programs Are Exact Recipes',
  12,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-2-1-1',
  'lesson-pf-2-1',
  'dialogue',
  1,
  '{"shady":"Cody, I told a robot to \'make me a sandwich\', and it put a sealed cheese wrapper right between two bread slices without opening it! 😅","cody":"Haha! That\'s because you didn\'t say \'open the wrapper first\'! A computer follows instructions literally — it never assumes anything!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-2-1-2',
  'lesson-pf-2-1',
  'text',
  2,
  '{"title":"A Program = An Unambiguous Recipe","body":"Imagine writing a recipe for someone who has never seen a kitchen in their life:<br>• If you tell them \'bake a cake\', they will stand there confused!<br>• But an exact, step-by-step recipe works every time:<br>&nbsp;&nbsp;1. Take a clean mixing bowl.<br>&nbsp;&nbsp;2. Add 2 cups of flour.<br>&nbsp;&nbsp;3. Add 2 eggs and whisk for 3 minutes.<br>&nbsp;&nbsp;4. Preheat the oven to 180°C and bake for 25 minutes.<br><br><strong>In Programming:</strong><br>A program is an ordered list of exact, unambiguous instructions. If you miss a step or leave room for ambiguity, the program encounters an error called a <strong>Bug</strong>!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-2-1-3',
  'lesson-pf-2-1',
  'quick_check',
  3,
  '{"title":"Quick Check: Precise Instructions","question":"If you command a robot \'Walk forward\' without giving a distance or stop condition, what happens?","options":{"A":"It walks two steps and stops politely","B":"It continues walking until it hits a wall because no stop condition was specified","C":"It walks backward","D":"It asks you for clarification"},"correct":"B","explanation":"Computers lack human intuition; without a specific boundary or stopping condition, it repeats the command indefinitely."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-2-2',
  'chap-pf-02',
  'pf-2-2-order-matters-sequence',
  2,
  '2.2: Order Matters — Sequence',
  12,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-2-2-1',
  'lesson-pf-2-2',
  'dialogue',
  1,
  '{"shady":"Once when I was in a rush, I put my shoes on before my socks... It was a total disaster and I couldn\'t walk! 😂","cody":"A great real-life lesson, Shady! Order is everything. In computer science, this foundational rule is called: Sequence!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-2-2-2',
  'lesson-pf-2-2',
  'text',
  2,
  '{"title":"The Principle of Sequence in Code","body":"Computers read code just like humans read an English book: <strong>line by line, from top to bottom</strong>.<br><br><strong>Logical Sequence Example:</strong><br>❌ Incorrect order breaking logic:<br>1. Squeeze toothpaste onto brush.<br>2. Unscrew the toothpaste cap.<br>3. Pick up the toothbrush from the cup.<br><br>✅ Correct logical Sequence:<br>1. Pick up the toothbrush from the cup.<br>2. Unscrew the toothpaste cap.<br>3. Squeeze toothpaste onto brush.<br><br><strong>In Code:</strong> If you try to display or print a calculation before calculating it, the program will crash with an error!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-2-2-3',
  'lesson-pf-2-2',
  'quick_check',
  3,
  '{"title":"Quick Check: Sequence in Code","question":"In a program: Line 1 calculates \'total = 5 + 3\', and Line 2 displays \'print(total)\'. What happens if you swap their order?","options":{"A":"The program works normally","B":"An error occurs because the program tries to print a variable before it exists","C":"The result doubles to 16","D":"The computer waits until Line 2 is calculated"},"correct":"B","explanation":"Due to sequential execution, you cannot use or display a variable before it has been created and assigned in a previous line."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-2-3',
  'chap-pf-02',
  'pf-2-3-programs-make-decisions-conditions',
  3,
  '2.3: Programs Make Decisions (Conditions: IF / ELSE)',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-2-3-1',
  'lesson-pf-2-3',
  'dialogue',
  1,
  '{"shady":"Every morning I check the weather: if it\'s raining, I grab an umbrella; otherwise, I put on sunglasses!","cody":"That is pure programmer logic, Shady! You just executed a condition: IF it is raining THEN take umbrella ELSE wear sunglasses!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-2-3-2',
  'lesson-pf-2-3',
  'text',
  2,
  '{"title":"Conditional Logic: How Programs Make Smart Decisions","body":"Smart programs don\'t just blindly repeat the same actions. They evaluate a situation by asking a question whose answer is either <strong>True (Yes)</strong> or <strong>False (No)</strong>.<br><br><strong>Structure of an IF / ELSE Statement:</strong><br><code>IF (a specific condition is True):<br>&nbsp;&nbsp;&nbsp;&nbsp;Execute Path A<br>ELSE:<br>&nbsp;&nbsp;&nbsp;&nbsp;Execute Path B</code><br><br><strong>Everyday Real Examples:</strong><br>• <strong>ATM Machine:</strong> IF your account balance ≥ withdrawal amount ← Dispense cash ELSE display \'Insufficient funds\'.<br>• <strong>School Portal:</strong> IF student score ≥ 50 ← Display \'Congratulations, you passed!\' ELSE display \'Please retake the quiz\'."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-2-3-3',
  'lesson-pf-2-3',
  'quick_check',
  3,
  '{"title":"Quick Check: Decision Making","question":"In a video game: \'If player coins reach 100, award an extra life.\' What programming concept is this?","options":{"A":"A Loop","B":"A Condition (IF Statement)","C":"Hardware component","D":"Compiler"},"correct":"B","explanation":"This is a conditional statement: when the condition (coins >= 100) becomes True, the reward is granted."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-2-4',
  'chap-pf-02',
  'pf-2-4-programs-repeat-loops',
  4,
  '2.4: Programs Repeat — Loops',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-2-4-1',
  'lesson-pf-2-4',
  'dialogue',
  1,
  '{"shady":"Every day I wake up, brush my teeth, eat breakfast, go to school, study, sleep... and repeat tomorrow! Repetition is exhausting 😴","cody":"You\'re living in a loop, Shady! Repetition is tiring for humans, but it\'s a computer\'s superpower! Programs can repeat tasks millions of times per second without ever getting tired!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-2-4-2',
  'lesson-pf-2-4',
  'text',
  2,
  '{"title":"Loops: The Power of Automation","body":"A <strong>Loop</strong> repeatedly executes a block of code multiple times without needing to write the code over and over again.<br><br><strong>Visual Comparison:</strong><br>❌ Without a Loop (Exhausting and messy):<br><code>print(\\"Hello\\")<br>print(\\"Hello\\")<br>print(\\"Hello\\")<br>print(\\"Hello\\")<br>print(\\"Hello\\")</code><br><br>✅ With a Loop (Clean and scalable):<br><code>REPEAT 5 times:<br>&nbsp;&nbsp;&nbsp;&nbsp;print(\\"Hello\\")</code><br><br><strong>Two Main Types of Loops:</strong><br>1. <strong>Count-controlled Loop:</strong> Runs a predetermined number of times (e.g., send report cards to 30 students).<br>2. <strong>Condition-controlled Loop:</strong> Runs until a specific condition becomes True or False (e.g., keep ringing the alarm until the user hits the snooze button)."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-2-4-3',
  'lesson-pf-2-4',
  'quick_check',
  3,
  '{"title":"Quick Check: Loops","question":"Which scenario represents the best use of a loop with a stopping condition?","options":{"A":"Adding two numbers together once","B":"Continuing to prompt the user for their password until they enter the correct one","C":"Displaying the title of a website","D":"Closing a laptop lid"},"correct":"B","explanation":"The attempt repeats continuously in a loop and stops only when the condition (password is correct) is satisfied."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pf-03',
  'course-programming-foundations',
  'chap-pf-03-algorithms-problem-solving',
  3,
  'Chapter 3: Algorithms — The Art of Problem Solving',
  'An algorithm is the logical plan before writing code. Learn the 3 rules of an algorithm, visual flowcharts, pseudocode planning, and how to debug errors.',
  '🧩',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-3-1',
  'chap-pf-03',
  'pf-3-1-what-is-an-algorithm',
  1,
  '3.1: What is an Algorithm?',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-3-1-1',
  'lesson-pf-3-1',
  'dialogue',
  1,
  '{"shady":"Google searches through billions of web pages and finds what I want in a fraction of a second! How is that even possible?!","cody":"No accidents in computer science, Shady! It is powered by brilliant algorithms! Great programmers design the plan and solution first, then write the code!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-3-1-2',
  'lesson-pf-3-1',
  'text',
  2,
  '{"title":"The Algorithm: The Blueprint Before the Code","body":"Named after the historic Persian mathematician <strong>Muhammad ibn Musa al-Khwarizmi</strong>, an algorithm is: <em>A finite, step-by-step procedure designed to solve a problem or accomplish a task</em>.<br><br><strong>3 Mandatory Conditions for a Valid Algorithm:</strong><br>1. <strong>Clear & Unambiguous:</strong> Every instruction leaves no room for confusion or multiple interpretations.<br>2. <strong>Finite (Has a definite end):</strong> It cannot run in an endless void forever; it must finish and produce a result.<br>3. <strong>Effective:</strong> Every step must be realistically executable and actually solve the problem.<br><br><strong>Example: Finding the Tallest Student in Class:</strong><br>1. Assume the first student is currently the \'Tallest\'.<br>2. Stand in front of the next student and compare their height with \'Tallest\'.<br>3. If this student is taller, update \'Tallest\' to be this student.<br>4. Repeat step 2 and 3 for all remaining students.<br>5. The student left in the \'Tallest\' spot is the tallest in class!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-3-1-3',
  'lesson-pf-3-1',
  'quick_check',
  3,
  '{"title":"Quick Check: Algorithms","question":"Navigation apps like Google Maps finding the fastest route to avoid traffic rely on:","options":{"A":"A smart pathfinding algorithm (like Dijkstra\'s algorithm)","B":"Random guessing","C":"Turning off street lights","D":"Coin flips"},"correct":"A","explanation":"Navigation software utilizes pathfinding algorithms to compute the shortest and fastest route across complex road networks."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-3-2',
  'chap-pf-03',
  'pf-3-2-flowcharts-visual-logic',
  2,
  '3.2: Visualizing Logic — Flowcharts',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-3-2-1',
  'lesson-pf-3-2',
  'dialogue',
  1,
  '{"shady":"I wrote out an algorithm in a whole page of text, but my friend got lost trying to follow the decision paths!","cody":"A picture is worth a thousand words, Shady! In software engineering, we map algorithms visually using a diagram called a Flowchart!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-3-2-2',
  'lesson-pf-3-2',
  'text',
  2,
  '{"title":"Flowcharts: The Visual Map of Program Flow","body":"A <strong>Flowchart</strong> is a visual diagram that illustrates the sequence of steps and decision paths in a program from start to finish.<br><br><strong>Universal Flowchart Symbols:</strong><br>• ⭕ <strong>Oval (Terminal):</strong> Represents the START or END of the program.<br>• ⬜ <strong>Rectangle (Process):</strong> Represents an action or calculation (e.g., total = a + b).<br>• ▱ <strong>Parallelogram (Input / Output):</strong> Represents receiving user input or displaying output to the screen.<br>• 🔷 <strong>Diamond (Decision):</strong> Represents a condition or question with two arrows branching out: one for (YES) and one for (NO).<br>• ➡️ <strong>Flowline Arrows:</strong> Connect symbols and indicate the direction of execution."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-3-2-3',
  'lesson-pf-3-2',
  'quick_check',
  3,
  '{"title":"Quick Check: Flowchart Shapes","question":"Which geometric shape should you use to represent: \'Enter Username and Password\'?","options":{"A":"Diamond (Decision)","B":"Parallelogram (Input / Output)","C":"Oval (Terminal)","D":"Hexagon"},"correct":"B","explanation":"Parallelograms are reserved specifically for Input (entering credentials) and Output operations."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-3-3',
  'chap-pf-03',
  'pf-3-3-pseudocode-planning-logic',
  3,
  '3.3: Pseudocode — Planning Before Code',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-3-3-1',
  'lesson-pf-3-3',
  'dialogue',
  1,
  '{"shady":"Cody, I want to code my project, but I get overwhelmed worrying about brackets, colons, and semicolons!","cody":"Professional programmers use a secret weapon: Pseudocode! It\'s an informal way to write program logic using simple plain English before typing actual code."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-3-3-2',
  'lesson-pf-3-3',
  'text',
  2,
  '{"title":"What is Pseudocode and Why Do Engineers Love It?","body":"<strong>Pseudocode</strong> (\'pseudo\' meaning imitation) is an informal, human-readable outline of a program that mimics code structure without strict syntax rules.<br><br><strong>Key Benefits of Pseudocode:</strong><br>• No compiler errors: no editor will yell at you for missing a colon.<br>• Uses intuitive keywords: START, INPUT, IF, ELSE, REPEAT, PRINT, END.<br>• Bridges the gap between an idea in your head and code in an editor.<br><br><strong>Example: Student Pass/Fail Checker:</strong><br><pre style=\\"background:#0F172A; padding:12px; border-radius:8px; color:#38BDF8;\\">START\\n  INPUT student_score\\n  IF student_score >= 50 THEN\\n      PRINT \\"Congratulations! You passed! 🎉\\"\\n  ELSE\\n      PRINT \\"Keep practicing and try again! 💪\\"\\n  END IF\\nEND</pre>"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-3-3-3',
  'lesson-pf-3-3',
  'quick_check',
  3,
  '{"title":"Quick Check: Pseudocode","question":"Can a computer execute pseudocode directly?","options":{"A":"Yes, because computers understand all human writing","B":"No, pseudocode is written for humans to plan logic and must be converted to a real programming language to run","C":"Yes, if written in capital letters","D":"Yes, if it has no spelling errors"},"correct":"B","explanation":"Pseudocode is an informal design tool for human readers; machines require actual programming languages."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-3-4',
  'chap-pf-03',
  'pf-3-4-debugging-fixing-errors',
  4,
  '3.4: Debugging — When Things Go Wrong',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-3-4-1',
  'lesson-pf-3-4',
  'dialogue',
  1,
  '{"shady":"Cody! I ran my code and scary red error text popped up! Does this mean I\'m terrible at programming? 😞","cody":"Not at all, Shady! Every programmer on Earth — even senior engineers at Google — gets errors every day! Bugs aren\'t failures; they are puzzles waiting to be solved through Debugging!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-3-4-2',
  'lesson-pf-3-4',
  'text',
  2,
  '{"title":"The Story of the Very First Computer Bug!","body":"In 1947, computer pioneer <strong>Grace Hopper</strong> was working on the Harvard Mark II computer (a machine that filled an entire room). Suddenly, the system malfunctioned.<br>When technicians inspected the relays, they discovered an actual <strong>moth</strong> trapped inside! They taped the insect into their logbook with the caption: <em>\'First actual case of bug being found\'</em>. From then on, computer errors were called <strong>Bugs</strong>, and fixing them was called <strong>Debugging</strong>!<br><br><strong>The 3 Major Types of Programming Errors:</strong><br>1. <strong>Syntax Error (Grammar Mistake):</strong><br>Typing an invalid command like <code>prnt(\\"Hello\\")</code> instead of <code>print</code>, or forgetting quotes.<br>→ Result: The computer refuses to run the program at all.<br><br>2. <strong>Logic Error (Flawed Thinking):</strong><br>The program runs completely, but the outcome is wrong (e.g., calculating average by adding numbers without dividing).<br>→ Result: Misleading answers without any crash.<br><br>3. <strong>Runtime Error (Crash While Running):</strong><br>The code starts fine, then hits an impossible operation like dividing by zero or opening a deleted file.<br>→ Result: The program crashes mid-execution."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-3-4-3',
  'lesson-pf-3-4',
  'quick_check',
  3,
  '{"title":"Quick Check: Bug Types","question":"Forgetting to close a parenthesis ) or quotation mark \\" is what type of error?","options":{"A":"Syntax Error","B":"Logic Error","C":"Hardware failure","D":"Network Error"},"correct":"A","explanation":"Missing punctuation or misspelling commands violates the syntax rules of the programming language."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pf-04',
  'course-programming-foundations',
  'chap-pf-04-programming-languages',
  4,
  'Chapter 4: Programming Languages',
  'Why are there hundreds of programming languages? High-level vs. low-level, compilers vs. interpreters, and a first hands-on look at real code.',
  '🗣️',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-4-1',
  'chap-pf-04',
  'pf-4-1-why-not-human-languages',
  1,
  '4.1: Why Can\'t We Just Talk to Computers in Plain English?',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-4-1-1',
  'lesson-pf-4-1',
  'dialogue',
  1,
  '{"shady":"If computers only understand 0 and 1, and humans think in spoken languages, how do we ever communicate?","cody":"Through programming languages! A programming language is an ingenious translator that takes readable human instructions and turns them into binary for the machine to execute!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-4-1-2',
  'lesson-pf-4-1',
  'text',
  2,
  '{"title":"Language Levels: From Human Thought to Silicon Gates","body":"<strong>1. High-Level Languages:</strong><br>• Examples: Python, JavaScript, Java, C#.<br>• Characteristics: Easy to read and write, using familiar words like <code>print, if, while</code>. You build apps quickly without worrying about computer transistors or RAM memory addresses.<br><br><strong>2. Low-Level Languages:</strong><br>• Examples: Assembly and Machine Code (Binary).<br>• Characteristics: Extremely close to the physical architecture of the CPU. Difficult for humans to read, but blazing fast because it communicates directly with hardware.<br><br><strong>The Full Translation Pipeline:</strong><br>Human Idea → High-Level Code → Compiler/Interpreter → Binary (0s & 1s) → CPU executes!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-4-1-3',
  'lesson-pf-4-1',
  'quick_check',
  3,
  '{"title":"Quick Check: Language Levels","question":"Which of the following is easiest for a beginner human to read and understand?","options":{"A":"Machine Code (01001000 01100101)","B":"Assembly Language","C":"Python (print(\'Hello\'))","D":"Hexadecimal memory dumps"},"correct":"C","explanation":"Python was intentionally designed with clean, English-like syntax to maximize human readability."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-4-2',
  'chap-pf-04',
  'pf-4-2-world-of-programming-languages',
  2,
  '4.2: The Universe of Programming Languages',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-4-2-1',
  'lesson-pf-4-2',
  'dialogue',
  1,
  '{"shady":"I see so many language names: Python, JavaScript, C++, Java, Swift... Why can\'t there just be one single language for everything?!","cody":"Imagine a carpentry toolbox with a hammer, saw, and screwdriver. Could you use a hammer to unscrew a tiny screw? Different programming languages are specialized tools tailored for different jobs!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-4-2-2',
  'lesson-pf-4-2',
  'text',
  2,
  '{"title":"Guide to Major Languages & Their Real-World Uses","body":"<strong>🐍 Python:</strong><br>The most popular language in the world! Renowned for readability. Dominates Artificial Intelligence (AI), Machine Learning, Data Science, and backend automation (Google, Netflix, NASA).<br><br><strong>🌐 JavaScript:</strong><br>The undisputed ruler of the Web! Runs natively inside every web browser, powering interactive websites, web games, and full-stack servers.<br><br><strong>☕ Java & Kotlin:</strong><br>Powerhouse languages behind Android mobile applications and enterprise banking infrastructure.<br><br><strong>🍎 Swift:</strong><br>Apple\'s official modern language designed for building iOS, iPadOS, and macOS apps.<br><br><strong>🎮 C++ & Rust:</strong><br>Ultra-high-performance languages delivering maximum speed. Power 3D game engines (Fortnite, Unreal Engine), aerospace guidance systems, and operating systems.<br><br><strong>🏗️ HTML & CSS:</strong><br>The foundational languages defining the structure and visual styling of web pages."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-4-2-3',
  'lesson-pf-4-2',
  'quick_check',
  3,
  '{"title":"Quick Check: Language Matching","question":"Which programming language is the global #1 choice for Artificial Intelligence (AI) and Data Science?","options":{"A":"Python","B":"HTML","C":"CSS","D":"Swift"},"correct":"A","explanation":"Python\'s massive ecosystem of AI libraries (like TensorFlow and PyTorch) makes it the worldwide standard for AI."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-4-3',
  'chap-pf-04',
  'pf-4-3-compiler-vs-interpreter',
  3,
  '4.3: How Does Code Actually Run? (Compiler vs. Interpreter)',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-4-3-1',
  'lesson-pf-4-3',
  'dialogue',
  1,
  '{"shady":"Cody, when I hit Run in Python, it runs instantly! What actually converts my text into machine execution?","cody":"There are two major kinds of translators in computer science: line-by-line live translators (Interpreters), and translators that compile the whole book before publishing (Compilers)!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-4-3-2',
  'lesson-pf-4-3',
  'text',
  2,
  '{"title":"Two Translation Approaches: Compilers vs. Interpreters","body":"<strong>1. The Interpreter (Live, Line-by-Line):</strong><br>• Examples: Python and JavaScript.<br>• How it works: Acts like a live speech interpreter! Reads line 1 → translates to machine code → executes it immediately → moves to line 2.<br>• Advantages: Instant testing, easy debugging, interactive experimentation.<br>• Trade-off: Slightly slower execution on massive mathematical computations compared to pre-compiled binaries.<br><br><strong>2. The Compiler (Ahead-of-Time Translation):</strong><br>• Examples: C++, Rust, Go.<br>• How it works: Acts like translating an entire book and printing a finished executable file (like a <code>.exe</code> file). Scans the entire project first. If a single syntax error exists, compilation fails.<br>• Advantages: Maximum raw execution speed and efficiency.<br>• Trade-off: You must re-compile after every change before running."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-4-3-3',
  'lesson-pf-4-3',
  'quick_check',
  3,
  '{"title":"Quick Check: Interpreter Behavior","question":"If your Python code has a syntax mistake on Line 10, what will the Python interpreter do?","options":{"A":"Execute Lines 1 through 9 successfully, then stop at Line 10 and display an error","B":"Refuse to run Line 1 at all","C":"Skip Line 10 silently and run Line 11","D":"Fix the mistake automatically"},"correct":"A","explanation":"Because an interpreter executes line-by-line, it runs preceding lines until it encounters the invalid instruction."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-4-4',
  'chap-pf-04',
  'pf-4-4-first-look-real-code',
  4,
  '4.4: First Look at Real Code',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-4-4-1',
  'lesson-pf-4-4',
  'dialogue',
  1,
  '{"shady":"Cody, looking at a black screen filled with lines of code used to intimidate me. It looked like ancient hieroglyphics!","cody":"No mystery at all, Shady! Real code reads like simple English sentences. Today, we\'ll read a complete real script line by line and see how clean it is!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-4-4-2',
  'lesson-pf-4-4',
  'code_example',
  2,
  '{"title":"Student Welcome Card — First Real Python Script","language":"Python","code":"# Welcome program for a new student in SPS Code Orbit\\nstudent_name = \\"Shady\\"\\nstudent_age = 16\\nschool_name = \\"Salam Prep\\"\\n\\nprint(\\"=== WELCOME TO CODE ORBIT! ===\\")\\nprint(\\"Student Name: \\" + student_name)\\nprint(\\"Student Age: \\" + str(student_age))\\nprint(\\"School: \\" + school_name)","explanation":"Notice how readable this is: we store the name, age, and school in labeled variables, then display them to the screen using print()!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-4-4-3',
  'lesson-pf-4-4',
  'text',
  3,
  '{"title":"Anatomy of Real Code Lines","body":"• Lines starting with <code>#</code> are <strong>Comments</strong>: explanatory notes written for human developers. The computer ignores them.<br>• <code>student_name = \\"Shady\\"</code>: We create a labeled memory container named <code>student_name</code> and store the text \\"Shady\\" inside.<br>• <code>print(...)</code>: The built-in output function that displays messages on the user\'s screen.<br>• <code>str(student_age)</code>: Converts the number 16 into text format so it can be combined with words."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-4-4-4',
  'lesson-pf-4-4',
  'quick_check',
  4,
  '{"title":"Quick Check: Code Reading","question":"If we edit Line 2 to be: student_name = \\"Omar\\", what will the program output for Student Name?","options":{"A":"Student Name: Shady","B":"Student Name: Omar","C":"Student Name: student_name","D":"The program crashes"},"correct":"B","explanation":"The variable now stores the new value \\"Omar\\", which will be output when print() references it."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pf-05',
  'course-programming-foundations',
  'chap-pf-05-the-world-of-web',
  5,
  'Chapter 5: The World of the Web',
  'How does the global internet actually work? Understand the Client-Server model, packets, subsea cables, and the Holy Trinity: HTML, CSS & JavaScript.',
  '🌐',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-5-1',
  'chap-pf-05',
  'pf-5-1-what-is-the-internet',
  1,
  '5.1: What is the Internet?',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-5-1-1',
  'lesson-pf-5-1',
  'dialogue',
  1,
  '{"shady":"I click a link in Cairo and a website hosted in California appears in less than a second! Is it magic?","cody":"Not magic, Shady! It is the largest physical engineering achievement in human history: thousands of kilometers of fiber-optic cables running across ocean floors at the speed of light!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-5-1-2',
  'lesson-pf-5-1',
  'text',
  2,
  '{"title":"The Internet: The Physical Global Network","body":"The internet is not an invisible cloud in the sky. It is a physical global infrastructure consisting of:<br>• Billions of interconnected computers, routers, and data center servers.<br>• Giant subsea fiber-optic cables traversing thousands of kilometers across ocean floors carrying light pulses.<br>• Every connected device has a unique numerical address called an <strong>IP Address</strong> (e.g., <code>192.168.1.1</code>).<br><br><strong>How Does Data Travel?</strong><br>Files and web pages are broken into tiny chunks called <strong>Packets</strong>. Each packet travels along the fastest available physical path across routers and reassembles in perfect order on your screen in milliseconds!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-5-1-3',
  'lesson-pf-5-1',
  'quick_check',
  3,
  '{"title":"Quick Check: Internet Protocol","question":"The unique digital address assigned to every device connected to the internet is known as an:","options":{"A":"IP Address","B":"RAM Number","C":"CPU Clock","D":"Binary Tag"},"correct":"A","explanation":"An IP (Internet Protocol) address acts as a unique digital street address routing data packets directly to your device."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-5-2',
  'chap-pf-05',
  'pf-5-2-how-websites-reach-you',
  2,
  '5.2: How Do Websites Reach You? (Client-Server Model)',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-5-2-1',
  'lesson-pf-5-2',
  'dialogue',
  1,
  '{"shady":"I type www.google.com in my browser... how does the webpage arrive so fast?","cody":"Think of dining at a restaurant! You are the customer (Client), and the kitchen is the Server. You order a dish (HTTP Request), and the kitchen prepares and serves it to your table (HTTP Response)!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-5-2-2',
  'lesson-pf-5-2',
  'text',
  2,
  '{"title":"The Client-Server Architecture","body":"Everything on the modern web relies on this architecture:<br><br><strong>1. The Client:</strong><br>Your device and web browser (Chrome, Safari, Firefox). Its job: send requests (Requests), receive web files, and render them on your screen.<br><br><strong>2. The Server:</strong><br>A high-performance computer running 24/7 in a secure data center. Its job: listen for requests, locate the requested files or database data, and send back a response (Response).<br><br><strong>Step-by-Step in One Second:</strong><br>1. You type a website domain into your browser.<br>2. DNS (Domain Name System) translates the domain name into the server\'s IP address.<br>3. Your browser sends an <strong>HTTP Request</strong>.<br>4. The server responds with page files: HTML + CSS + JavaScript.<br>5. Your browser parses the files and renders the interactive page on your screen!<br><br><em>Security tip: Always look for the lock icon 🔒 in your address bar — it means the connection is encrypted via HTTPS!</em>"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-5-2-3',
  'lesson-pf-5-2',
  'quick_check',
  3,
  '{"title":"Quick Check: Web Security","question":"What does the \'S\' stand for in HTTPS (https://)?","options":{"A":"Speed","B":"Secure (Encrypted connection)","C":"Software","D":"Server"},"correct":"B","explanation":"HTTPS stands for HyperText Transfer Protocol Secure, meaning data transmitted between client and server is encrypted."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-5-3',
  'chap-pf-05',
  'pf-5-3-html-css-javascript-trinity',
  3,
  '5.3: HTML, CSS & JavaScript — The Holy Trinity of Web',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-5-3-1',
  'lesson-pf-5-3',
  'dialogue',
  1,
  '{"shady":"Cody, every website mentions HTML, CSS, and JavaScript... what does each of them actually do?","cody":"Imagine building a house, Shady: HTML is the bricks and foundation (Structure). CSS is the paint, wallpaper, and interior design (Styling). JavaScript is the electricity, elevators, and smart lights (Interactivity)!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-5-3-2',
  'lesson-pf-5-3',
  'text',
  2,
  '{"title":"The Holy Trinity of Web Development","body":"<strong>1. HTML (Structure & Content):</strong><br>Defines <em>what</em> is on the page: headings, paragraphs, images, buttons, and links.<br><code>&lt;h1&gt;Welcome to SPS!&lt;/h1&gt;<br>&lt;p&gt;Start your journey into web development.&lt;/p&gt;<br>&lt;button&gt;Click Here&lt;/button&gt;</code><br><br><strong>2. CSS (Presentation & Style):</strong><br>Defines <em>how it looks</em>: colors, fonts, spacing, layout grids, and responsiveness across phones and desktops.<br><code>h1 { color: #38BDF8; font-size: 32px; }<br>button { background: #10B981; border-radius: 8px; }</code><br><br><strong>3. JavaScript (Behavior & Interactivity):</strong><br>Defines <em>what happens</em> when users interact: opening modals, playing sound effects, sending form data, and updating content without reloading the page!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-5-3-3',
  'lesson-pf-5-3',
  'quick_check',
  3,
  '{"title":"Quick Check: Web Roles","question":"A button reads \'Buy Now\', is styled in vibrant green, and displays a popup \'Item Added!\' when clicked. What handles each piece in order?","options":{"A":"HTML creates the button → CSS styles it green → JavaScript handles the click popup","B":"CSS creates the button → JavaScript styles it → HTML handles the click","C":"JavaScript handles all three","D":"HTML handles all three"},"correct":"A","explanation":"HTML supplies the button element, CSS applies the green styling, and JavaScript responds to the click event."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-5-4',
  'chap-pf-05',
  'pf-5-4-what-can-you-build',
  4,
  '5.4: What Can You Build with Code?',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-5-4-1',
  'lesson-pf-5-4',
  'dialogue',
  1,
  '{"shady":"Cody, once I learn programming, what kind of real-world projects can I actually build myself?","cody":"Almost anything that exists on a screen, Shady! Websites like YouTube, games like Minecraft, smart AI chatbots, mobile apps, and even autonomous robots and spacecraft controls!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-5-4-2',
  'lesson-pf-5-4',
  'text',
  2,
  '{"title":"Limitless Horizons: What Programming Empowers You to Build","body":"Programming is not just about writing syntax; it is a <strong>superpower for creative innovation</strong>:<br><br>🌐 <strong>Web Applications:</strong><br>Build educational platforms, social communities, and global e-commerce portals.<br><br>📱 <strong>Mobile Apps:</strong><br>Create smartphone apps for chat, fitness, study organizers, and games used by people worldwide.<br><br>🤖 <strong>Artificial Intelligence (AI & Data):</strong><br>Train machine learning models that analyze photos, understand speech, and assist doctors in diagnosing medical conditions.<br><br>🎮 <strong>Video Game Development:</strong><br>Design 3D physics engines, character mechanics, and interactive game worlds.<br><br>🚀 <strong>Robotics & Space Exploration:</strong><br>Program drones, self-driving cars, and robotic rovers exploring the surface of Mars!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-5-4-3',
  'lesson-pf-5-4',
  'quick_check',
  3,
  '{"title":"Quick Check: Developer Mindset","question":"Every tech industry titan and master programmer started their journey at:","options":{"A":"Born with innate coding knowledge","B":"The exact same starting line you are at right now: curiosity, hands-on practice, and learning from mistakes","C":"Only by buying supercomputers","D":"Memorizing textbooks without touching a keyboard"},"correct":"B","explanation":"Every great engineer started with the simplest \'Hello World\' program and built skills gradually through curiosity and practice."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pf-06',
  'course-programming-foundations',
  'chap-pf-06-choose-your-track',
  6,
  'Chapter 6: Choose Your Track',
  'Congratulations! You have mastered all foundational concepts. Compare Python vs. JavaScript, understand Frontend vs. Backend, and confidently pick your Level 1 track!',
  '🎯',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-6-1',
  'chap-pf-06',
  'pf-6-1-why-python-first',
  1,
  '6.1: Python — The Language Everyone Loves',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-6-1-1',
  'lesson-pf-6-1',
  'dialogue',
  1,
  '{"shady":"Cody, everyone keeps telling me: if you want to start coding, start with Python Adventures! Why is Python so universally recommended?","cody":"Because Python was built on a brilliant philosophy: \'Readable code is better than complex code\'. It reads like plain English without the confusing syntax traps of older languages!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-6-1-2',
  'lesson-pf-6-1',
  'text',
  2,
  '{"title":"Side-by-Side Comparison: The Magic of Python","body":"Let\'s compare the exact same task: printing \'Hello World\' in two different languages:<br><br><strong>In Java (Intimidating for a beginner):</strong><br><pre style=\\"background:#0F172A; padding:10px; border-radius:6px; color:#F87171;\\">public class Main {\\n    public static void main(String[] args) {\\n        System.out.println(\\"Hello World\\");\\n    }\\n}</pre><br><strong>In Python (Clean and intuitive):</strong><br><pre style=\\"background:#0F172A; padding:10px; border-radius:6px; color:#34D399;\\">print(\\"Hello World\\")</pre><br>One single, elegant line in Python achieves what requires 5 complex lines in Java! Furthermore, Python is the global #1 language for Artificial Intelligence, Data Science, and automation."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-6-1-3',
  'lesson-pf-6-1',
  'quick_check',
  3,
  '{"title":"Quick Check: Python Strengths","question":"In which of the following technological domains does Python lead the entire industry?","options":{"A":"Artificial Intelligence (AI) and Data Science","B":"Creating phone wallpaper designs only","C":"Video editing software","D":"Old TV hardware"},"correct":"A","explanation":"Python is the undisputed leader in AI and Data Science thanks to top libraries like PyTorch and TensorFlow."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-6-2',
  'chap-pf-06',
  'pf-6-2-javascript-web-language',
  2,
  '6.2: JavaScript — The Language of the Internet',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-6-2-1',
  'lesson-pf-6-2',
  'dialogue',
  1,
  '{"shady":"Cody, if my true passion is building interactive websites like YouTube and Facebook that friends can open in their browsers, what should I choose?","cody":"Then JavaScript is your golden path! JavaScript runs through the veins of the web. You can write code, hit save, and see visual results live on your screen instantly!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-6-2-2',
  'lesson-pf-6-2',
  'text',
  2,
  '{"title":"JavaScript: The Engine of the Modern Web","body":"Open any web browser, press F12 to open Developer Tools, and click Console: you can type JavaScript commands right there and watch the page react immediately!<br><br><strong>Where Does JavaScript Run Today?</strong><br>• <strong>In the Browser (Frontend):</strong> Building interactive UI, web animations, and browser games.<br>• <strong>On Servers (Backend):</strong> Powered by Node.js, JavaScript builds fast, scalable server APIs.<br>• <strong>Mobile Apps:</strong> With frameworks like React Native, you can build iOS and Android apps with a single codebase!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-6-2-3',
  'lesson-pf-6-2',
  'quick_check',
  3,
  '{"title":"Quick Check: JavaScript Execution","question":"To test a line of JavaScript right now, do you need to install heavy software?","options":{"A":"Yes, you must buy specialized hardware","B":"No, your web browser already contains a high-speed JavaScript engine built right in","C":"Yes, you need a paid subscription","D":"It only runs inside Google servers"},"correct":"B","explanation":"Modern browsers like Chrome, Edge, and Safari have built-in JS engines (like V8) ready to run code immediately."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-6-3',
  'chap-pf-06',
  'pf-6-3-frontend-vs-backend',
  3,
  '6.3: Frontend vs. Backend — Who Does What?',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-6-3-1',
  'lesson-pf-6-3',
  'dialogue',
  1,
  '{"shady":"I keep hearing people say \'I\'m a Frontend developer\' or \'I do Backend\'... Are they working at totally different companies?!","cody":"No, Shady! They are two sides of the exact same product! Think of a restaurant: Frontend is the dining room, menus, and decor. Backend is the kitchen, pantry, and secure safe behind the scenes!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-6-3-2',
  'lesson-pf-6-3',
  'text',
  2,
  '{"title":"Comprehensive Comparison: Frontend vs. Backend","body":"<strong>1. Frontend (The Client-Side User Experience):</strong><br>• Everything the user sees, touches, and clicks on their screen.<br>• Responsible for: Visual layout, responsive design, animations, and typography.<br>• Core technologies: HTML, CSS, JavaScript, React.<br><br><strong>2. Backend (Behind-the-Scenes Architecture):</strong><br>• The hidden, secure engine running on cloud servers.<br>• Responsible for: User authentication, saving student scores, database queries, and payment processing.<br>• Core technologies: Python, Node.js, PHP, PostgreSQL, Cloud databases.<br><br><strong>The Full-Stack Developer:</strong><br>An engineer who masters both frontend and backend development to build complete applications independently!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-6-3-3',
  'lesson-pf-6-3',
  'quick_check',
  3,
  '{"title":"Quick Check: Specialization","question":"Designing how video thumbnails appear on Instagram and styling the heart like button is the job of:","options":{"A":"Frontend Developer","B":"Backend Developer","C":"Database Administrator only","D":"Hardware engineer"},"correct":"A","explanation":"Everything visual and interactive that users see and touch on screen is crafted by frontend developers."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pf-6-4',
  'chap-pf-06',
  'pf-6-4-your-journey-begins',
  4,
  '6.4: Your Journey Begins — Choose Your Track!',
  15,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-6-4-1',
  'lesson-pf-6-4',
  'dialogue',
  1,
  '{"shady":"Cody! I can\'t believe I finished all 24 lessons in Programming Foundations and truly understand concepts that used to scare me! I\'m ready to write real code!","cody":"Congratulations, champion! You now possess a rock-solid algorithmic and conceptual foundation. Pick your Level 1 track and launch into the orbit of coding creativity!"}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-6-4-2',
  'lesson-pf-6-4',
  'text',
  2,
  '{"title":"Golden Review: Everything You Mastered in Foundations","body":"Let\'s review the major pillars of computer science you now master:<br>• <strong>Technology & Hardware:</strong> Hardware vs. software, and the Input → Process → Output cycle.<br>• <strong>Machine Language:</strong> The binary system of 0s and 1s and how electrical switches represent data.<br>• <strong>Program Architecture:</strong> Sequence (order), Conditions (decision-making), and Loops (automation).<br>• <strong>Algorithmic Thinking:</strong> Designing algorithms, drawing Flowcharts, writing Pseudocode, and Debugging errors.<br>• <strong>The Internet & Web:</strong> Subsea cable infrastructure, the Client-Server model, and the HTML/CSS/JS trinity.<br><br><strong>Your Available Level 1 Tracks on SPS Code Orbit:</strong><br>1. 🐍 <strong>Python Adventures (Level 1):</strong> Cleanest syntax, interactive terminal games, and entry into Artificial Intelligence.<br>2. 🌐 <strong>Web Explorers (Level 1):</strong> Build real web pages with HTML5 & CSS3 and see visual designs live.<br>3. ⚡ <strong>JavaScript Adventures (Level 1):</strong> Dive into browser interactivity and web logic."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);
INSERT INTO lesson_blocks (id, lesson_id, block_type, order_index, content_json) VALUES (
  'blk-lesson-pf-6-4-3',
  'lesson-pf-6-4',
  'quick_check',
  3,
  '{"title":"Quick Check: Ready to Launch","question":"What is the best mindset when writing your first lines of real code?","options":{"A":"Giving up whenever an error message appears","B":"Reading error messages calmly, experimenting with hands-on practice, and knowing that every bug is a learning step","C":"Copy-pasting without understanding","D":"Avoiding running code"},"correct":"B","explanation":"Great programmers embrace challenges, learn from debugging, and build expertise through active practice."}'
) ON DUPLICATE KEY UPDATE block_type = VALUES(block_type), content_json = VALUES(content_json);


-- Course: Python Foundations
INSERT INTO courses (id, academic_group_id, title, slug, description, image_url, accent_color, is_published, created_at, updated_at) VALUES (
  'course-python-foundations',
  'ag-prep',
  'Python Foundations',
  'python-foundations',
  'Build robust programming fundamentals from scratch using Python. Master variables, data types, operators, branching logic, loops, collections, and structured problem-solving.',
  '/assets/courses/algo.png',
  '#0EA5E9',
  1, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), description = VALUES(description), is_published = 1, image_url = VALUES(image_url), accent_color = VALUES(accent_color);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pyf-01',
  'course-python-foundations',
  'interpreter-and-execution',
  1,
  'The Python Interpreter & Script Execution',
  'Learn how the Python runtime executes code line by line, formatted console output, comments, and syntax error diagnosis.',
  '⚡',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-1-1',
  'chap-pyf-01',
  'interpreter-execution-flow',
  1,
  'The Interpreter & Line-by-Line Execution',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-1-2',
  'chap-pyf-01',
  'output-sep-end',
  2,
  'Output Customization with sep and end',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-1-3',
  'chap-pyf-01',
  'comments-code-documentation',
  3,
  'Comments & Code Documentation',
  8,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-1-4',
  'chap-pyf-01',
  'syntax-errors-vs-runtime',
  4,
  'Syntax Errors vs Execution Flow',
  12,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pyf-02',
  'course-python-foundations',
  'variables-types-memory',
  2,
  'Variables, Types & Memory Binding',
  'Explore dynamic typing in Python, int, float, str, bool data types, explicit type casting, and modern f-string formatting.',
  '🏷️',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-2-1',
  'chap-pyf-02',
  'dynamic-typing-primitives',
  1,
  'Dynamic Typing: int, float, str, bool',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-2-2',
  'chap-pyf-02',
  'reassignment-and-references',
  2,
  'Variable Reassignment & Memory References',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-2-3',
  'chap-pyf-02',
  'explicit-type-conversion',
  3,
  'Explicit Type Conversion (int, float, str)',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-2-4',
  'chap-pyf-02',
  'modern-fstrings',
  4,
  'Modern String Interpolation with f-Strings',
  12,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pyf-03',
  'course-python-foundations',
  'arithmetic-modulo-expressions',
  3,
  'Arithmetic, Modulo & Expressions',
  'Master operator precedence (PEMDAS), floor division (//), the remainder operator (%), and compound assignment shortcuts (+=, -=).',
  '➗',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-3-1',
  'chap-pyf-03',
  'operator-precedence-pemdas',
  1,
  'Operator Precedence & PEMDAS',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-3-2',
  'chap-pyf-03',
  'floor-division-and-modulo',
  2,
  'Floor Division (//) & Modulo (%)',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-3-3',
  'chap-pyf-03',
  'compound-assignment-operators',
  3,
  'Compound Assignment (+=, -=, *=)',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-3-4',
  'chap-pyf-03',
  'averages-and-unit-conversions',
  4,
  'Calculating Averages & Unit Conversions',
  12,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pyf-04',
  'course-python-foundations',
  'boolean-logic-conditionals',
  4,
  'Boolean Expressions & Conditional Branching',
  'Explore comparison operators, logical and/or/not operators, multi-way if-elif-else branching, and numerical range validation.',
  '🧭',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-4-1',
  'chap-pyf-04',
  'comparison-operators-deep-dive',
  1,
  'Comparison Operators (==, !=, <, >, <=, >=)',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-4-2',
  'chap-pyf-04',
  'logical-operators-and-or-not',
  2,
  'Logical Operators (and, or, not)',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-4-3',
  'chap-pyf-04',
  'multi-way-branching',
  3,
  'Multi-Way Branching with if-elif-else',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-4-4',
  'chap-pyf-04',
  'validating-numerical-ranges',
  4,
  'Validating Numerical Ranges',
  12,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pyf-05',
  'course-python-foundations',
  'iteration-sequences-for-loops',
  5,
  'Iteration & Sequences with for Loops',
  'Traverse sequences, control loops with range(start, stop, step), apply accumulator patterns, and construct nested loops.',
  '🔄',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-5-1',
  'chap-pyf-05',
  'traversing-sequences-for',
  1,
  'Sequence Traversal with for',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-5-2',
  'chap-pyf-05',
  'range-start-stop-step',
  2,
  'Controlling Ranges: start, stop, step',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-5-3',
  'chap-pyf-05',
  'accumulator-patterns',
  3,
  'The Accumulator Pattern: Summing & Counting',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-5-4',
  'chap-pyf-05',
  'nested-loops-grids',
  4,
  'Nested Loops & Coordinate Grids',
  12,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pyf-06',
  'course-python-foundations',
  'while-loops-and-state',
  6,
  'Event-Driven & State-Based while Loops',
  'Understand sentinel-controlled loops, state flags, break and continue statements, and robust input validation loops.',
  '🎛️',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-6-1',
  'chap-pyf-06',
  'sentinel-controlled-loops',
  1,
  'Sentinel-Controlled Loops',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-6-2',
  'chap-pyf-06',
  'flag-variables-state',
  2,
  'Flag Variables & State Tracking',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-6-3',
  'chap-pyf-06',
  'break-and-continue',
  3,
  'Loop Flow Control: break and continue',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-6-4',
  'chap-pyf-06',
  'input-validation-loops',
  4,
  'Input Validation Loops',
  12,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pyf-07',
  'course-python-foundations',
  'string-manipulation-slicing',
  7,
  'String Manipulation & Slicing',
  'Master string immutability, index notation, slicing with [start:stop:step], and essential string methods (lower, upper, replace, split).',
  '✂️',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-7-1',
  'chap-pyf-07',
  'string-immutability-indexing',
  1,
  'String Immutability & Indexing',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-7-2',
  'chap-pyf-07',
  'string-slicing-notation',
  2,
  'Slicing with [start:stop:step]',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-7-3',
  'chap-pyf-07',
  'case-transformation-methods',
  3,
  'Case Transformation & Replacement (.upper, .replace)',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-7-4',
  'chap-pyf-07',
  'splitting-and-joining',
  4,
  'Splitting & Joining Strings (.split, .join)',
  12,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pyf-08',
  'course-python-foundations',
  'lists-and-sequence-operations',
  8,
  'Lists & Sequence Operations',
  'Master list mutability, modification methods (append, insert, pop, remove), searching and aggregation (min, max, sum), and sorting.',
  '📋',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-8-1',
  'chap-pyf-08',
  'list-mutability',
  1,
  'List Mutability & Memory Representation',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-8-2',
  'chap-pyf-08',
  'list-modifications-methods',
  2,
  'List Modifications: append, insert, pop, remove',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-8-3',
  'chap-pyf-08',
  'searching-aggregation-functions',
  3,
  'Searching & Aggregation: min, max, sum, in',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-8-4',
  'chap-pyf-08',
  'sorting-reversing-sequences',
  4,
  'Sorting & Reversing Sequences (.sort, sorted)',
  12,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pyf-09',
  'course-python-foundations',
  'dictionaries-key-value-mapping',
  9,
  'Dictionaries & Key-Value Mapping',
  'Understand associative mapping with key-value pairs, accessing and mutating dictionary entries, iterating keys/values, and structuring records.',
  '📖',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-9-1',
  'chap-pyf-09',
  'key-value-mechanics',
  1,
  'Key-Value Pair Mechanics',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-9-2',
  'chap-pyf-09',
  'mutating-dictionary-entries',
  2,
  'Accessing & Mutating Dictionary Entries',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-9-3',
  'chap-pyf-09',
  'iterating-dict-items',
  3,
  'Iterating Keys, Values, and Items',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-9-4',
  'chap-pyf-09',
  'structuring-records',
  4,
  'Structuring Student & Astronaut Records',
  12,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at) VALUES (
  'chap-pyf-10',
  'course-python-foundations',
  'modular-functions-reusable-logic',
  10,
  'Modular Functions & Reusable Logic',
  'Decompose programs into pure functions, understand return values vs side effects, scope rules (local vs global), and build the capstone console app.',
  '🧩',
  100, NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), chapter_number = VALUES(chapter_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-10-1',
  'chap-pyf-10',
  'function-parameters-arguments',
  1,
  'Defining Functions with Parameters',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-10-2',
  'chap-pyf-10',
  'return-values-vs-side-effects',
  2,
  'Return Values vs Side Effects',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-10-3',
  'chap-pyf-10',
  'variable-scope-rules',
  3,
  'Variable Scope: Local vs Global',
  10,
  25,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);
INSERT INTO lessons (id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward, created_at, updated_at) VALUES (
  'lesson-pyf-10-4',
  'chap-pyf-10',
  'capstone-orbital-console',
  4,
  'Capstone: Interactive Orbital Console Application',
  15,
  50,
  NOW(), NOW()
) ON DUPLICATE KEY UPDATE title = VALUES(title), slug = VALUES(slug), lesson_number = VALUES(lesson_number);





-- =============================================================
-- SPS CODE ORBIT — Python Level 2 Curriculum REBUILD
-- Source: sps_python_level2_curriculum.md (2026-09-13)
-- COMPLETELY REPLACES previous Python Level 2 content
-- DO NOT import into live DB — run only during full rebuild
-- =============================================================

-- ── DELETE existing Python Level 2 content ──────────────────
DELETE FROM lesson_blocks WHERE lesson_id IN (SELECT id FROM lessons WHERE course_id = 'course-python-level-2');
DELETE FROM exam_questions WHERE exam_id IN (SELECT id FROM exams WHERE course_id = 'course-python-level-2');
DELETE FROM exams WHERE course_id = 'course-python-level-2';
DELETE FROM lessons WHERE course_id = 'course-python-level-2';
DELETE FROM chapters WHERE course_id = 'course-python-level-2';
DELETE FROM courses WHERE id = 'course-python-level-2';

-- ── Course ──────────────────────────────────────────────────
INSERT INTO courses (id, slug, title, description, academic_group_id, image_url, accent_color, status)
VALUES (
  'course-python-level-2',
  'python-level-2',
  'Python Level 2: Code Orbit',
  'By the end of this course, students will write professional-quality Python programs using dictionaries, file I/O, modules, error handling, list comprehensions, advanced functions, and the basics of Object-Oriented Programming.',
  'ag-prep',
  '/assets/courses/algo.png',
  '#8B5CF6',
  'active'
);

-- ── Chapters & Lessons ──────────────────────────────────────
INSERT INTO chapters (id, course_id, slug, chapter_number, title, description)
VALUES ('chap-pyl2-01', 'course-python-level-2', 'strings-going-deeper', 1, 'Strings — Going Deeper', 'Students already know basic strings from Level 1. This chapter goes much deeper — slicing, powerful methods, and professional output formatting.');

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-1-1', 'course-python-level-2', 'chap-pyl2-01', 'lesson-pyl2-1-1', 1, 'String Indexing and Slicing', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-1-1-dialogue', 'lesson-pyl2-1-1', 'dialogue', '{"shady": "I have a string: ''Shady Ahmed''. I want to extract just ''Shady'' automatically \\u2014 without counting and typing it manually each time. Numbered seats? Starting from what number? So I could say: give me seats 0 to 4?", "cody": "That''s exactly what slicing is for. Every character in a string sits in a numbered seat \\u2014 like passengers on a train. Starting from zero. Always zero in Python. S = seat 0, h = seat 1, a = seat 2... Exactly. And Python has a clean syntax for exactly that."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-1-1-concept', 'lesson-pyl2-1-1', 'concept', '{"title": "Every character in a string has a numbered position (index). You can extract any part of a string using slicing.", "body": "The student can access individual characters and extract substrings using index and slice notation."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-1-1-showcase', 'lesson-pyl2-1-1', 'showcase', '{"title": "Example", "language": "Python", "code": "name = \\"Shady Ahmed\\"\\n\\nprint(name[0])     # S   (first character)\\nprint(name[6])     # A   (seventh character)\\nprint(name[-1])    # d   (last character)\\nprint(name[-5])    # A   (fifth from the end)", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-1-1-playground', 'lesson-pyl2-1-1', 'playground', '{"title": "Playground", "language": "Python", "code": "# Practise string indexing and slicing\\nfull_name = \\"Python Coder\\"\\n\\n# 1. Print the first character\\nprint(full_name[0])\\n\\n# 2. Print the last character\\nprint(full_name[-1])\\n\\n# 3. Print just \\"Python\\" using slicing\\nprint(full_name[:6])\\n\\n# 4. Print \\"Coder\\" using slicing\\nprint(full_name[7:])\\n\\n# 5. Print the full name reversed\\nprint(full_name[::-1])\\n\\n# Now try with your own name:\\nmy_name = \\"Your Name Here\\"\\n# Extract just the first name (assuming you know where it ends):", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-1-1-challenge', 'lesson-pyl2-1-1', 'exercise', '{"title": "Mission", "instruction": "1. Create a variable containing any sentence (at least 10 characters)\\n2. Print the first 5 characters\\n3. Print the last 5 characters\\n4. Print every second character of the whole sentence\\n5. Print the sentence reversed \\u2014 using only slicing, one line", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-1-1-quiz', 'lesson-pyl2-1-1', 'quiz', '{"question": "What does `\\"SPS Code Orbit\\"[4:8]` return?", "code": "", "options": [{"id": "A", "text": "\\"SPS \\""}, {"id": "B", "text": "\\"Code\\""}, {"id": "C", "text": "\\"Cod\\""}, {"id": "D", "text": "\\" Cod\\""}], "correct": "B", "explanation": "Indexing starts at 0. `[4:8]` means characters at positions 4, 5, 6, 7 \\u2014 which are ''C'', ''o'', ''d'', ''e''. Position 8 is not included. Count carefully: S(0) P(1) S(2) '' ''(3) C(4) o(5) d(6) e(7)."}', 6);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-1-2', 'course-python-level-2', 'chap-pyl2-01', 'lesson-pyl2-1-2', 2, 'Powerful String Methods', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-1-2-dialogue', 'lesson-pyl2-1-2', 'dialogue', '{"shady": "I got a string from the user: ''ahmed.ali@school.eg'' I want to check that it actually looks like an email \\u2014 has an @ sign, ends with .eg, that kind of thing. Do I have to write all that logic myself? Like what? All of those are built in?", "cody": "Nope. Python has string methods that do most of that in one line. .find() tells you if something is inside the string. .endswith() checks what it ends with. .split() breaks it into pieces at a separator. And about twenty more. Let''s go through the most useful ones."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-1-2-concept', 'lesson-pyl2-1-2', 'concept', '{"title": "Python strings come with dozens of built-in methods for searching, replacing, splitting, and checking content.", "body": "The student uses `.find()`, `.replace()`, `.split()`, `.join()`, `.startswith()`, `.endswith()`, `.count()`, `.isdigit()`, `.isalpha()` correctly."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-1-2-showcase', 'lesson-pyl2-1-2', 'showcase', '{"title": "Example", "language": "Python", "code": "text = \\"Welcome to SPS Code Orbit!\\"\\n\\n# .find() \\u2014 returns the index of the first match, or -1 if not found\\nprint(text.find(\\"SPS\\"))       # 11\\nprint(text.find(\\"Python\\"))    # -1 (not found)\\n\\n# .count() \\u2014 how many times does something appear?\\nprint(text.count(\\"o\\"))        # 3\\n\\n# .startswith() / .endswith() \\u2014 returns True or False\\nprint(text.startswith(\\"Welcome\\"))   # True\\nprint(text.endswith(\\"!\\"))           # True\\nprint(text.endswith(\\".\\"))           # False\\n\\n# in operator \\u2014 quickest way to check if something is inside\\nprint(\\"SPS\\" in text)    # True\\nprint(\\"Java\\" in text)   # False", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-1-2-playground', 'lesson-pyl2-1-2', 'playground', '{"title": "Playground", "language": "Python", "code": "# Email validator (simplified)\\nemail = input(\\"Enter your email: \\")\\n\\nhas_at = \\"@\\" in email\\nhas_dot = \\".\\" in email\\nparts = email.split(\\"@\\")\\n\\nprint(f\\"Contains @: {has_at}\\")\\nprint(f\\"Contains .: {has_dot}\\")\\n\\nif has_at and len(parts) == 2:\\n    username = parts[0]\\n    domain = parts[1]\\n    print(f\\"Username: {username}\\")\\n    print(f\\"Domain: {domain}\\")\\n    print(f\\"Ends with .eg: {email.endswith(''.eg'')}\\")\\nelse:\\n    print(\\"That doesn''t look like a valid email.\\")", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-1-2-challenge', 'lesson-pyl2-1-2', 'exercise', '{"title": "Mission", "instruction": "1. Ask the user to enter a sentence\\n2. Count how many times the letter ''a'' appears (case-insensitive \\u2014 hint: use .lower() first)\\n3. Replace every space with an underscore and print the result\\n4. Split the sentence into words and print how many words it has\\n5. Check if the sentence ends with a ''?'' or ''!''", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-1-2-quiz', 'lesson-pyl2-1-2', 'quiz', '{"question": "You run `result = \\"Hello\\".replace(\\"l\\", \\"r\\")` then `print(\\"Hello\\")`. What prints?", "code": "", "options": [{"id": "A", "text": "\\"Herro\\""}, {"id": "B", "text": "\\"Hello\\""}, {"id": "C", "text": "Nothing \\u2014 the replace modified in place"}, {"id": "D", "text": "SyntaxError"}], "correct": "B", "explanation": "String methods **never** modify the original string \\u2014 strings are immutable. `.replace()` returns a **new** string. Since we printed `\\"Hello\\"` directly (not `result`), we see the unchanged original."}', 6);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-1-3', 'course-python-level-2', 'chap-pyl2-01', 'lesson-pyl2-1-3', 3, 'Multi-line Strings and Number Formatting', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-1-3-dialogue', 'lesson-pyl2-1-3', 'dialogue', '{"shady": "I''m trying to print a receipt \\u2014 items on the left, prices on the right, all lined up in columns. But my numbers keep jumping around. But f-strings just substitute variables, right? Can you show me with the receipt?", "cody": "That''s a formatting problem. f-strings can fix it. That''s what you''ve been using them for. But they can do much more \\u2014 you can control how many decimal places, how wide the field is, and whether text is left or right-aligned. That''s exactly the example we''ll use."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-1-3-concept', 'lesson-pyl2-1-3', 'concept', '{"title": "Triple quotes create multi-line strings. f-strings can format numbers with precise control over decimal places and alignment.", "body": "The student writes multi-line strings and formats numbers using f-string format specifiers."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-1-3-showcase', 'lesson-pyl2-1-3', 'showcase', '{"title": "Example", "language": "Python", "code": "# Triple quotes let you span multiple lines\\nmessage = \\"\\"\\"\\nHello!\\nWelcome to SPS Code Orbit.\\nWe hope you enjoy learning Python.\\n\\"\\"\\"\\nprint(message)\\n\\n# Also useful for long SQL queries, HTML snippets, or long prompts", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-1-3-playground', 'lesson-pyl2-1-3', 'playground', '{"title": "Playground", "language": "Python", "code": "# Generate a formatted invoice\\nprint(\\"=\\" * 35)\\nprint(f\\"{''SPS Code Orbit Store'':^35}\\")\\nprint(\\"=\\" * 35)\\nprint(f\\"{''Item'':<20} {''Price'':>10}\\")\\nprint(\\"-\\" * 35)\\n\\nitems = [\\n    (\\"Python Textbook\\", 150.00),\\n    (\\"USB Cable\\", 25.50),\\n    (\\"Notebook (pack)\\", 18.75),\\n    (\\"Pen Set\\", 12.00),\\n]\\n\\ntotal = 0\\nfor item_name, item_price in items:\\n    print(f\\"{item_name:<20} {item_price:>10.2f}\\")\\n    total += item_price\\n\\nprint(\\"-\\" * 35)\\nprint(f\\"{''TOTAL'':<20} {total:>10.2f}\\")\\nprint(\\"=\\" * 35)", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-1-3-challenge', 'lesson-pyl2-1-3', 'exercise', '{"title": "Mission", "instruction": "Build a student report card using formatted output:\\n1. A header: \\"==== Student Report Card ====\\"\\n2. Student name (left-aligned, padded to 20 chars) and grade (right-aligned)\\n3. Print scores for 4 subjects \\u2014 each score with exactly 1 decimal place\\n4. Print the average with 2 decimal places\\n5. Use - * 30 as a separator line", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-1-3-quiz', 'lesson-pyl2-1-3', 'quiz', '{"question": "What does `f\\"{3.14159:.2f}\\"` produce?", "code": "", "options": [{"id": "A", "text": "\\"3.14159\\""}, {"id": "B", "text": "\\"3.14\\""}, {"id": "C", "text": "\\"3.1\\""}, {"id": "D", "text": "\\"3.142\\""}], "correct": "B", "explanation": "`:.2f` means \\"format as a float with exactly 2 decimal places\\". Python rounds the result, so 3.14159 becomes 3.14."}', 6);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-1-4', 'course-python-level-2', 'chap-pyl2-01', 'lesson-pyl2-1-4', 4, 'Mini Project — Text Analyser', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-1-4-dialogue', 'lesson-pyl2-1-4', 'dialogue', '{"shady": "I want to build something useful with strings \\u2014 not just print practice. Something real. That sounds like something that could actually be useful.", "cody": "How about a text analyser? You paste in any text, and it tells you: how long it is, how many words, the most common letter, whether it''s mostly uppercase, and a cleaned-up version. It is. Grammar checkers, search engines, translation tools \\u2014 they all start with exactly this kind of analysis."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-1-4-concept', 'lesson-pyl2-1-4', 'concept', '{"title": "Apply all string skills together to build a real utility.", "body": "The student builds a program that analyses any text and reports multiple statistics about it."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-1-4-showcase', 'lesson-pyl2-1-4', 'showcase', '{"title": "Example", "language": "Python", "code": "def analyse_text(text):\\n    # \\u2500\\u2500 Basic stats \\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\n    char_count = len(text)\\n    char_no_spaces = len(text.replace(\\" \\", \\"\\"))\\n    word_count = len(text.split())\\n    line_count = text.count(\\"\\\\n\\") + 1\\n\\n    # \\u2500\\u2500 Case analysis \\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\n    upper_count = sum(1 for c in text if c.isupper())\\n    lower_count = sum(1 for c in text if c.islower())\\n\\n    # \\u2500\\u2500 Most common letter \\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\n    letters = [c.lower() for c in text if c.isalpha()]\\n    most_common = max(set(letters), key=letters.count) if letters else \\"N/A\\"\\n    most_common_count = letters.count(most_common) if letters else 0\\n\\n    # \\u2500\\u2500 Cleaned version \\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\n    cleaned = \\" \\".join(text.split())    # collapses multiple spaces\\n\\n    # \\u2500\\u2500 Report \\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\n    print(\\"=\\" * 40)\\n    print(f\\"{''TEXT ANALYSIS REPORT'':^40}\\")\\n    print(\\"=\\" * 40)\\n    print(f\\"{''Characters (total)'':<25} {char_count:>10}\\")\\n    print(f\\"{''Characters (no spaces)'':<25} {char_no_spaces:>10}\\")\\n    print(f\\"{''Words'':<25} {word_count:>10}\\")\\n    print(f\\"{''Lines'':<25} {line_count:>10}\\")\\n    print(f\\"{''Uppercase letters'':<25} {upper_count:>10}\\")\\n    print(f\\"{''Lowercase letters'':<25} {lower_count:>10}\\")\\n    print(f\\"{''Most common letter'':<25} {most_common!r:>10} (\\u00d7{most_common_count})\\")\\n    print(\\"-\\" * 40)\\n    print(\\"Cleaned text:\\")\\n    print(cleaned[:100] + (\\"...\\" if len(cleaned) > 100 else \\"\\"))\\n    print(\\"=\\" * 40)\\n\\n\\n# \\u2500\\u2500 Main \\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\nprint(\\"=== Text Analyser ===\\")\\nprint(\\"Paste your text below, then press Enter twice:\\\\n\\")\\n\\nlines = []\\nwhile True:\\n    line = input()\\n    if line == \\"\\":\\n        break\\n    lines.append(line)\\n\\nuser_text = \\"\\\\n\\".join(lines)\\n\\nif user_text.strip():\\n    analyse_text(user_text)\\nelse:\\n    print(\\"No text entered.\\")", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-1-4-playground', 'lesson-pyl2-1-4', 'playground', '{"title": "Playground", "language": "Python", "code": "# Simplified text analyser \\u2014 extend it!\\ndef analyse_text(text):\\n    print(f\\"Characters: {len(text)}\\")\\n    print(f\\"Words: {len(text.split())}\\")\\n    print(f\\"Uppercase version: {text.upper()}\\")\\n    print(f\\"Reversed: {text[::-1]}\\")\\n\\n    # TODO: Add \\u2014 count vowels (a, e, i, o, u)\\n    # TODO: Add \\u2014 print the most common word\\n    # TODO: Add \\u2014 check if it contains any digits\\n\\ntext = input(\\"Enter a sentence: \\")\\nanalyse_text(text)", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-1-4-challenge', 'lesson-pyl2-1-4', 'exercise', '{"title": "Mission", "instruction": "Extend the starter code above to also:\\n1. Count and print the number of vowels (a, e, i, o, u \\u2014 case-insensitive)\\n2. Print the sentence with all spaces replaced by hyphens\\n3. Print each unique word on its own line (no duplicates, sorted A-Z)\\n   Hint: convert to a list of words, then use set() and sorted()", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-1-4-quiz', 'lesson-pyl2-1-4', 'quiz', '{"question": "A student writes `words = sentence.split()` then `print(len(words))`. What does this print?", "code": "", "options": [{"id": "A", "text": "The number of characters in the sentence"}, {"id": "B", "text": "The number of words in the sentence"}, {"id": "C", "text": "The number of unique words"}, {"id": "D", "text": "Always 1"}], "correct": "B", "explanation": "`.split()` without arguments splits on spaces and returns a list of words. `len()` of that list gives the number of words."}', 6);

INSERT INTO exams (id, course_id, chapter_id, title, pass_threshold, exam_type)
VALUES ('exam-pyl2-ch01', 'course-python-level-2', 'chap-pyl2-01', 'Chapter 1 Exam', 60, 'chapter');
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch01-01', 'exam-pyl2-ch01', 'What does `"Hello World"[6:]` return?', 'MCQ', '[{"id": "A", "text": "World"}]', 'A', '', 1);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch01-02', 'exam-pyl2-ch01', 'What does `"hello".replace("l", "r")` return?', 'MCQ', '[{"id": "A", "text": "herlo"}]', 'A', '', 2);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch01-03', 'exam-pyl2-ch01', '`"one,two,three".split(",")` returns:', 'MCQ', '[{"id": "A", "text": "`"}]', 'A', '', 3);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch01-04', 'exam-pyl2-ch01', 'What does `f"{99.5:.0f}"` produce?', 'MCQ', '[{"id": "A", "text": "99.5"}]', 'A', '', 4);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch01-05', 'exam-pyl2-ch01', 'Write a function `reverse_words(sentence)` that takes a sentence string, reverses the order of words (not letters), and returns the result. Example: `"Hello World Python"` → `"Python World Hello"`. Hint: use `.split()`, reverse the list, and `.join()`.

---

---', 'Coding', '[]', 'A', '', 5);

INSERT INTO chapters (id, course_id, slug, chapter_number, title, description)
VALUES ('chap-pyl2-02', 'course-python-level-2', 'dictionaries', 2, 'Key-Value Storage — Dictionaries', 'Dictionaries are one of Python''s most important structures. They store data as key-value pairs for fast, named lookup.');

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-2-1', 'course-python-level-2', 'chap-pyl2-02', 'lesson-pyl2-2-1', 1, 'What Is a Dictionary?', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-2-1-dialogue', 'lesson-pyl2-2-1', 'dialogue', '{"shady": "I want to store a student''s name, grade, and score together. I used a list but it''s messy \\u2014 list[0] for name, list[1] for grade... I keep forgetting which index means what. Like a word dictionary? So I give each piece of data a name instead of a number?", "cody": "That''s because a list isn''t the right tool here. You want a dictionary. Same idea! You look up a word \\u2014 that''s the key \\u2014 and you get its definition \\u2014 that''s the value. You look up ''score'' and get 95. You look up ''name'' and get ''Ahmed''. No index numbers to remember. Exactly. That''s a dictionary."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-2-1-concept', 'lesson-pyl2-2-1', 'concept', '{"title": "A dictionary maps unique keys to values \\u2014 like a contacts list where every name points to a phone number.", "body": "The student creates dictionaries, accesses values by key, adds new entries, and updates existing ones."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-2-1-showcase', 'lesson-pyl2-2-1', 'showcase', '{"title": "Example", "language": "Python", "code": "# Curly braces, key: value pairs, separated by commas\\nstudent = {\\n    \\"name\\": \\"Ahmed\\",\\n    \\"grade\\": 10,\\n    \\"score\\": 95,\\n    \\"city\\": \\"Cairo\\"\\n}\\n\\nprint(student)\\n# {''name'': ''Ahmed'', ''grade'': 10, ''score'': 95, ''city'': ''Cairo''}", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-2-1-playground', 'lesson-pyl2-2-1', 'playground', '{"title": "Playground", "language": "Python", "code": "# Student profile using a dictionary\\nstudent = {\\n    \\"name\\": \\"Shady\\",\\n    \\"school\\": \\"Salam Prep\\",\\n    \\"grade\\": 10,\\n    \\"favourite_subject\\": \\"Python\\"\\n}\\n\\n# Print each value\\nprint(f\\"Name: {student[''name'']}\\")\\nprint(f\\"School: {student[''school'']}\\")\\n\\n# TODO: Add \\"score\\" key with value 88\\n# TODO: Update \\"grade\\" to 11\\n# TODO: Print the number of keys in the dictionary\\n# TODO: Check if \\"email\\" is in the dictionary (should print False)", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-2-1-challenge', 'lesson-pyl2-2-1', 'exercise', '{"title": "Mission", "instruction": "1. Create a dictionary representing a book: title, author, year, pages, available (True/False)\\n2. Print a nicely formatted \\"book card\\" using f-strings\\n3. Update the ''available'' key to False (simulate checking it out)\\n4. Add a ''borrower'' key with your name\\n5. Delete the ''pages'' key\\n6. Print the final dictionary", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-2-1-quiz', 'lesson-pyl2-2-1', 'quiz', '{"question": "What happens when you run `d = {\\"x\\": 1}` then `print(d[\\"y\\"])`?", "code": "", "options": [{"id": "A", "text": "Prints `None`"}, {"id": "B", "text": "Prints `0`"}, {"id": "C", "text": "Raises a `KeyError`"}, {"id": "D", "text": "Prints `\\"y\\"`"}], "correct": "C", "explanation": "Accessing a key that doesn''t exist in a dictionary raises a `KeyError`. The dictionary only has `\\"x\\"` \\u2014 `\\"y\\"` was never added. Use `.get()` (next lesson) to avoid this crash."}', 6);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-2-2', 'course-python-level-2', 'chap-pyl2-02', 'lesson-pyl2-2-2', 2, 'Dictionary Methods', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-2-2-dialogue', 'lesson-pyl2-2-2', 'dialogue', '{"shady": "My program crashed with KeyError again! I looked up a student who wasn''t in the dictionary. What does ''safe'' mean here? Doctors have a rule: first, do no harm. Seems like .get() is Python''s version of that.", "cody": "That''s why .get() exists. It''s the safe version of dict[key]. Instead of crashing when the key doesn''t exist, .get() just returns None \\u2014 or a default you choose. Your program keeps running. Ha \\u2014 not bad. And there are a few more methods that follow the same spirit."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-2-2-concept', 'lesson-pyl2-2-2', 'concept', '{"title": "Python dictionaries have built-in methods that make working with them safer and more efficient.", "body": "The student uses `.get()`, `.keys()`, `.values()`, `.items()`, `.pop()`, and `.update()` correctly."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-2-2-showcase', 'lesson-pyl2-2-2', 'showcase', '{"title": "Example", "language": "Python", "code": "student = {\\"name\\": \\"Ahmed\\", \\"score\\": 95}\\n\\n# \\u274c Risky:\\nprint(student[\\"email\\"])    # KeyError \\u2014 crashes!\\n\\n# \\u2705 Safe:\\nprint(student.get(\\"email\\"))            # None  (no crash)\\nprint(student.get(\\"email\\", \\"N/A\\"))     # N/A   (custom default)\\nprint(student.get(\\"score\\", 0))         # 95    (key exists \\u2014 returns the value)", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-2-2-playground', 'lesson-pyl2-2-2', 'playground', '{"title": "Playground", "language": "Python", "code": "# Student lookup system\\ndatabase = {\\n    \\"S001\\": {\\"name\\": \\"Ahmed\\", \\"score\\": 95},\\n    \\"S002\\": {\\"name\\": \\"Sara\\", \\"score\\": 88},\\n    \\"S003\\": {\\"name\\": \\"Omar\\", \\"score\\": 72},\\n}\\n\\nstudent_id = input(\\"Enter student ID (e.g. S001): \\")\\n\\n# TODO: Use .get() to safely look up the student\\n# If found: print their name and score\\n# If not found: print \\"Student not found\\"\\n\\n# Hint:\\nresult = database.get(student_id)\\nif result:\\n    print(f\\"Name: {result.get(''name'', ''Unknown'')}\\")\\n    print(f\\"Score: {result.get(''score'', ''N/A'')}\\")\\nelse:\\n    print(\\"Student not found.\\")", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-2-2-challenge', 'lesson-pyl2-2-2', 'exercise', '{"title": "Mission", "instruction": "1. Create a dictionary of 5 countries and their capitals\\n2. Use .get() to look up a capital \\u2014 test with a country that IS in the dict and one that ISN''T\\n3. Use .keys() to print all countries in the dictionary\\n4. Use .values() to find and print the capital that comes last alphabetically\\n   Hint: sorted(dict.values())[-1]\\n5. Use .pop() to remove one country \\u2014 print the removed capital", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-2-2-quiz', 'lesson-pyl2-2-2', 'quiz', '{"question": "`scores = {\\"Ali\\": 80}`. What does `scores.get(\\"Sara\\", 0)` return?", "code": "", "options": [{"id": "A", "text": "`KeyError`"}, {"id": "B", "text": "`None`"}, {"id": "C", "text": "`0`"}, {"id": "D", "text": "`\\"Sara\\"`"}], "correct": "C", "explanation": "`.get(\\"Sara\\", 0)` looks for key `\\"Sara\\"`. It doesn''t exist, so instead of crashing, it returns the default value `0` that we provided as the second argument."}', 6);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-2-3', 'course-python-level-2', 'chap-pyl2-02', 'lesson-pyl2-2-3', 3, 'Looping Through Dictionaries', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-2-3-dialogue', 'lesson-pyl2-2-3', 'dialogue', '{"shady": "I have a dictionary of 30 students and their grades. Do I have to write 30 print statements to show them all? But I know how to loop through a list. A dictionary isn''t a list... Both at once \\u2014 how?", "cody": "Of course not \\u2014 that''s what loops are for. You can loop through a dictionary too. In fact, there are three useful ways \\u2014 through the keys, through the values, or through both at once. With .items() \\u2014 it gives you the key and value together, every iteration. Let me show you."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-2-3-concept', 'lesson-pyl2-2-3', 'concept', '{"title": "You can loop through a dictionary''s keys, values, or key-value pairs to process all entries automatically.", "body": "The student loops through a dictionary using `.keys()`, `.values()`, and `.items()`, and builds a formatted class report."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-2-3-showcase', 'lesson-pyl2-2-3', 'showcase', '{"title": "Example", "language": "Python", "code": "grades = {\\"Ahmed\\": 95, \\"Sara\\": 88, \\"Omar\\": 72, \\"Nour\\": 91}\\n\\nfor student in grades:           # iterates over keys\\n    print(student)\\n\\n# Ahmed\\n# Sara\\n# Omar\\n# Nour", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-2-3-playground', 'lesson-pyl2-2-3', 'playground', '{"title": "Playground", "language": "Python", "code": "# Inventory price checker\\ninventory = {\\n    \\"Notebook\\": 15.00,\\n    \\"Pen\\":       3.50,\\n    \\"Ruler\\":     8.00,\\n    \\"Eraser\\":    2.00,\\n    \\"Calculator\\": 75.00\\n}\\n\\nprint(\\"All items in stock:\\")\\nfor item, price in inventory.items():\\n    print(f\\"  {item:<15} {price:>8.2f} EGP\\")\\n\\n# TODO: Print the most expensive item (hint: use max() with .items())\\n# TODO: Count how many items cost less than 10 EGP\\n# TODO: Calculate and print the total value of all inventory", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-2-3-challenge', 'lesson-pyl2-2-3', 'exercise', '{"title": "Mission", "instruction": "1. Create a dictionary: {''math'': 85, ''english'': 90, ''science'': 78, ''arabic'': 88}\\n2. Loop through it and print each subject + score on one line, formatted\\n3. Calculate the average of all scores using a loop\\n4. Find and print which subject has the highest score\\n   Hint: max(grades, key=grades.get)  returns the key with the max value\\n5. Print only the subjects where the student scored above 85", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-2-3-quiz', 'lesson-pyl2-2-3', 'quiz', '{"question": "What does `for key, value in my_dict.items():` do?", "code": "", "options": [{"id": "A", "text": "Loops through only the keys"}, {"id": "B", "text": "Loops through only the values"}, {"id": "C", "text": "Loops through each key-value pair together"}, {"id": "D", "text": "Raises a SyntaxError \\u2014 you can''t unpack two variables in a for loop"}], "correct": "C", "explanation": "`.items()` returns pairs like `(\\"Ahmed\\", 95)`. Python automatically unpacks each pair into `key` and `value`. This is the standard way to loop through a dictionary when you need both."}', 6);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-2-4', 'course-python-level-2', 'chap-pyl2-02', 'lesson-pyl2-2-4', 4, 'Mini Project — Student Grade Book', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-2-4-dialogue', 'lesson-pyl2-2-4', 'dialogue', '{"shady": "I want to build something teachers could actually use \\u2014 add students, look them up, update grades, print a report. Sounds like a real program.", "cody": "Let''s build it. A dictionary of student names mapping to their scores. Four operations: add, lookup, update, report. It is. Most real-world programs are a loop around a menu that calls functions. You''ve got everything you need."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-2-4-concept', 'lesson-pyl2-2-4', 'concept', '{"title": "Apply dictionary skills to build an interactive grade book that stores, retrieves, and reports student grades.", "body": "The student builds a multi-function grade book using a dictionary, demonstrating all Chapter 2 skills."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-2-4-showcase', 'lesson-pyl2-2-4', 'showcase', '{"title": "Example", "language": "Python", "code": "def add_student(grade_book, name, score):\\n    if name in grade_book:\\n        print(f\\"  \\u26a0 ''{name}'' already exists. Use ''update'' to change their score.\\")\\n    else:\\n        grade_book[name] = score\\n        print(f\\"  \\u2714 {name} added with score {score}.\\")\\n\\ndef lookup_student(grade_book, name):\\n    score = grade_book.get(name)\\n    if score is not None:\\n        status = \\"Pass\\" if score >= 50 else \\"Fail\\"\\n        print(f\\"  {name}: {score}/100 \\u2014 {status}\\")\\n    else:\\n        print(f\\"  ''{name}'' not found in grade book.\\")\\n\\ndef update_student(grade_book, name, new_score):\\n    if name in grade_book:\\n        old = grade_book[name]\\n        grade_book[name] = new_score\\n        print(f\\"  \\u2714 {name}: {old} \\u2192 {new_score}\\")\\n    else:\\n        print(f\\"  ''{name}'' not found. Use ''add'' to create them.\\")\\n\\ndef print_report(grade_book):\\n    if not grade_book:\\n        print(\\"  Grade book is empty.\\")\\n        return\\n    print(\\"\\\\n\\" + \\"=\\" * 35)\\n    print(f\\"{''GRADE BOOK REPORT'':^35}\\")\\n    print(\\"=\\" * 35)\\n    print(f\\"  {''Name'':<18} {''Score'':>5} {''Result'':>8}\\")\\n    print(\\"  \\" + \\"-\\" * 33)\\n    total = 0\\n    passed = 0\\n    for name, score in sorted(grade_book.items(), key=lambda x: x[1], reverse=True):\\n        result = \\"Pass\\" if score >= 50 else \\"Fail\\"\\n        if score >= 50:\\n            passed += 1\\n        print(f\\"  {name:<18} {score:>5} {result:>8}\\")\\n        total += score\\n    average = total / len(grade_book)\\n    print(\\"  \\" + \\"-\\" * 33)\\n    print(f\\"  Students: {len(grade_book)}   \\"\\n          f\\"Passed: {passed}   \\"\\n          f\\"Average: {average:.1f}\\")\\n    print(\\"=\\" * 35)\\n\\n# \\u2500\\u2500 Main menu \\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\ngrade_book = {}\\n\\nmenu = \\"\\"\\"\\nGrade Book \\u2014 Choose an action:\\n  1. Add student\\n  2. Look up student\\n  3. Update score\\n  4. Print report\\n  5. Exit\\n\\"\\"\\"\\n\\nwhile True:\\n    print(menu)\\n    choice = input(\\"Your choice (1-5): \\").strip()\\n\\n    if choice == \\"1\\":\\n        name  = input(\\"  Student name: \\").strip()\\n        score = int(input(\\"  Score (0-100): \\"))\\n        add_student(grade_book, name, score)\\n\\n    elif choice == \\"2\\":\\n        name = input(\\"  Student name: \\").strip()\\n        lookup_student(grade_book, name)\\n\\n    elif choice == \\"3\\":\\n        name  = input(\\"  Student name: \\").strip()\\n        score = int(input(\\"  New score: \\"))\\n        update_student(grade_book, name, score)\\n\\n    elif choice == \\"4\\":\\n        print_report(grade_book)\\n\\n    elif choice == \\"5\\":\\n        print(\\"Goodbye!\\")\\n        break\\n\\n    else:\\n        print(\\"  Invalid choice \\u2014 please enter 1 to 5.\\")", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-2-4-playground', 'lesson-pyl2-2-4', 'playground', '{"title": "Playground", "language": "Python", "code": "# Simplified starter \\u2014 extend it yourself\\ngrade_book = {}\\n\\ndef add_student(name, score):\\n    grade_book[name] = score\\n    print(f\\"Added: {name} \\u2014 {score}\\")\\n\\ndef print_all():\\n    for name, score in grade_book.items():\\n        print(f\\"{name}: {score}\\")\\n\\n# Add some students\\nadd_student(\\"Ahmed\\", 95)\\nadd_student(\\"Sara\\", 88)\\nadd_student(\\"Omar\\", 72)\\n\\nprint_all()\\n\\n# TODO: Write a function find_top_student() that returns the name with the highest score\\n# TODO: Write a function class_average() that returns the mean score", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-2-4-challenge', 'lesson-pyl2-2-4', 'exercise', '{"title": "Mission", "instruction": "Extend the grade book so that:\\n1. Each student stores a LIST of scores (for multiple subjects), not just one score\\n   e.g.  {\\"Ahmed\\": [95, 88, 72]}\\n2. The lookup shows each score and the student''s average\\n3. The report shows overall class average (average of all students'' averages)", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-2-4-quiz', 'lesson-pyl2-2-4', 'quiz', '{"question": "In the grade book program, why is `grade_book.get(name)` better than `grade_book[name]` for the lookup function?", "code": "", "options": [{"id": "A", "text": "`.get()` is faster for large dictionaries"}, {"id": "B", "text": "`.get()` returns `None` instead of crashing when the name doesn''t exist"}, {"id": "C", "text": "`dict[key]` only works with integer keys"}, {"id": "D", "text": "There is no difference"}], "correct": "B", "explanation": "If a teacher searches for a student not in the grade book, `dict[key]` would raise a `KeyError` and crash the program. `.get()` safely returns `None`, allowing us to print a friendly \\"not found\\" message instead."}', 6);

INSERT INTO exams (id, course_id, chapter_id, title, pass_threshold, exam_type)
VALUES ('exam-pyl2-ch02', 'course-python-level-2', 'chap-pyl2-02', 'Chapter 2 Exam', 60, 'chapter');
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch02-01', 'exam-pyl2-ch02', '`d = {"a": 1, "b": 2}`. What does `d.get("c", 99)` return?', 'MCQ', '[{"id": "A", "text": "`KeyError`  B) `None`  C) `99`"}]', 'A', '', 1);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch02-02', 'exam-pyl2-ch02', 'Which method returns key-value pairs that can be unpacked in a for loop?', 'MCQ', '[{"id": "A", "text": "`.keys()`  B) `.values()`  C) `.items()`"}]', 'A', '', 2);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch02-03', 'exam-pyl2-ch02', '`d = {"x": 10}`. After `d.pop("x")`, what is `len(d)`?', 'MCQ', '[{"id": "A", "text": "1  B) 10  C) 0"}]', 'A', '', 3);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch02-04', 'exam-pyl2-ch02', '`scores = {"Ali": 80, "May": 95, "Tom": 60}`. What does `max(scores, key=scores.get)` return?', 'MCQ', '[{"id": "A", "text": "`95`  B) `"}]', 'A', '', 4);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch02-05', 'exam-pyl2-ch02', 'Write a function `word_count(sentence)` that returns a dictionary where each key is a unique word from the sentence and each value is how many times that word appears. Example: `"the cat sat on the mat"` → `{''the'': 2, ''cat'': 1, ''sat'': 1, ''on'': 1, ''mat'': 1}`.

---

---', 'Coding', '[]', 'A', '', 5);

INSERT INTO chapters (id, course_id, slug, chapter_number, title, description)
VALUES ('chap-pyl2-03', 'course-python-level-2', 'tuples-and-sets', 3, 'Tuples and Sets', 'Two more collection types with specific strengths. Tuples for fixed data, sets for unique collections.');

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-3-1', 'course-python-level-2', 'chap-pyl2-03', 'lesson-pyl2-3-1', 1, 'Tuples — Immutable Sequences', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-3-1-dialogue', 'lesson-pyl2-3-1', 'dialogue', '{"shady": "I''m storing GPS coordinates \\u2014 latitude and longitude. I used a list but someone on my team accidentally changed the values. So it''s a list... but read-only? What other data should never change?", "cody": "That''s exactly the problem tuples solve. A tuple is like a list with a lock on it \\u2014 once you create it, nobody can change it. That''s a good way to think about it. The immutability isn''t a limitation \\u2014 it''s a guarantee. It says: this data represents a fixed point. Don''t touch it. RGB colours, days of the week, country codes, the options in a dropdown \\u2014 anything that is fixed by definition."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-3-1-concept', 'lesson-pyl2-3-1', 'concept', '{"title": "A tuple is like a list that cannot be changed after creation. Use it for data that must stay fixed.", "body": "The student creates tuples, accesses elements, unpacks them, and understands why immutability is a feature."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-3-1-showcase', 'lesson-pyl2-3-1', 'showcase', '{"title": "Example", "language": "Python", "code": "# Round brackets (or no brackets at all)\\ncoordinates = (30.0444, 31.2357)    # Cairo lat/long\\nrgb_red = (255, 0, 0)\\ndays = (\\"Mon\\", \\"Tue\\", \\"Wed\\", \\"Thu\\", \\"Fri\\", \\"Sat\\", \\"Sun\\")\\n\\n# Single-element tuple \\u2014 needs a trailing comma!\\nsingle = (42,)         # \\u2705 tuple\\nnot_tuple = (42)       # \\u274c this is just the integer 42", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-3-1-playground', 'lesson-pyl2-3-1', 'playground', '{"title": "Playground", "language": "Python", "code": "# Coordinate tracker using tuples\\nlocations = [\\n    (\\"Cairo\\", 30.0444, 31.2357),\\n    (\\"Alexandria\\", 31.2001, 29.9187),\\n    (\\"Assiut\\", 27.1783, 31.1859),\\n    (\\"Luxor\\", 25.6872, 32.6396)\\n]\\n\\nprint(f\\"{''City'':<15} {''Latitude'':>10} {''Longitude'':>10}\\")\\nprint(\\"-\\" * 37)\\n\\nfor city, lat, lon in locations:\\n    print(f\\"{city:<15} {lat:>10.4f} {lon:>10.4f}\\")\\n\\n# TODO: Add one more Egyptian city with its coordinates\\n# TODO: Find and print the city with the highest latitude (furthest north)", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-3-1-challenge', 'lesson-pyl2-3-1', 'exercise', '{"title": "Mission", "instruction": "1. Create a tuple representing a student: (name, grade, score)\\n2. Unpack it into three separate variables using one line\\n3. Print a formatted sentence using the three variables\\n4. Try to change the score \\u2014 observe the error\\n5. Create a list of 3 such student tuples, loop through it, and print each one formatted", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-3-1-quiz', 'lesson-pyl2-3-1', 'quiz', '{"question": "What is the output of `a, b = (5, 10)` then `a, b = b, a` then `print(a, b)`?", "code": "", "options": [{"id": "A", "text": "`5 10`"}, {"id": "B", "text": "`10 10`"}, {"id": "C", "text": "`10 5`"}, {"id": "D", "text": "`SyntaxError`"}], "correct": "C", "explanation": "`a, b = (5, 10)` gives a=5, b=10. Then `a, b = b, a` swaps them \\u2014 Python evaluates the right side first (10, 5) then assigns, giving a=10, b=5."}', 6);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-3-2', 'course-python-level-2', 'chap-pyl2-03', 'lesson-pyl2-3-2', 2, 'Sets — Collections of Unique Values', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-3-2-dialogue', 'lesson-pyl2-3-2', 'dialogue', '{"shady": "I have a list of students who attended Monday''s class and another list for Tuesday. I want to know who attended both days. Set? Like a math set? And Python can do all of that?", "cody": "That''s a classic set intersection problem. Exactly \\u2014 same idea. Union: everyone who attended either day. Intersection: only those who came both days. Difference: who came Monday but skipped Tuesday. In one symbol each. Let me show you."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-3-2-concept', 'lesson-pyl2-3-2', 'concept', '{"title": "A set stores only unique values \\u2014 duplicates are automatically removed. Great for membership checks and set operations.", "body": "The student creates sets, adds/removes elements, and uses union, intersection, and difference."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-3-2-showcase', 'lesson-pyl2-3-2', 'showcase', '{"title": "Example", "language": "Python", "code": "# Sets use curly braces \\u2014 but without key:value pairs\\nfruits = {\\"apple\\", \\"banana\\", \\"mango\\", \\"apple\\", \\"banana\\"}\\nprint(fruits)   # {''apple'', ''banana'', ''mango''}  \\u2014 duplicates removed!\\n\\n# IMPORTANT: {} alone creates an empty DICT, not a set\\nempty_set = set()    # \\u2705 correct\\nempty_dict = {}      # \\u2705 this is a dict, not a set", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-3-2-playground', 'lesson-pyl2-3-2', 'playground', '{"title": "Playground", "language": "Python", "code": "# Attendance tracker\\nclass_a = {\\"Ahmed\\", \\"Sara\\", \\"Omar\\", \\"Nour\\", \\"Ali\\"}\\nclass_b = {\\"Sara\\", \\"Nour\\", \\"Maya\\", \\"Karim\\", \\"Ahmed\\"}\\n\\nprint(\\"Class A:\\", class_a)\\nprint(\\"Class B:\\", class_b)\\nprint()\\n\\n# Students in both classes\\nprint(\\"In both:\\", class_a & class_b)\\n\\n# All unique students across both classes\\nprint(\\"Total unique students:\\", class_a | class_b)\\n\\n# In A but not B\\nprint(\\"Only in Class A:\\", class_a - class_b)\\n\\n# TODO: Find students in exactly one class (not both)\\n# TODO: Print the total count of unique students across both classes\\n# TODO: Add \\"Layla\\" to class_a, then check if she''s in class_b", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-3-2-challenge', 'lesson-pyl2-3-2', 'exercise', '{"title": "Mission", "instruction": "1. Given: list1 = [1, 2, 3, 2, 1, 4, 5, 4]\\n          list2 = [3, 4, 6, 7, 3]\\n2. Convert both to sets\\n3. Find numbers that appear in BOTH lists\\n4. Find numbers that appear in list1 but NOT list2\\n5. Find all unique numbers across both lists combined\\n6. Print each result with a label", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-3-2-quiz', 'lesson-pyl2-3-2', 'quiz', '{"question": "`s = {1, 2, 3}`. What does `s.discard(10)` do?", "code": "", "options": [{"id": "A", "text": "Raises a `KeyError`"}, {"id": "B", "text": "Raises a `ValueError`"}, {"id": "C", "text": "Does nothing \\u2014 no error"}, {"id": "D", "text": "Adds 10 to the set"}], "correct": "C", "explanation": "`.discard()` is the \\"safe\\" remove \\u2014 if the element doesn''t exist, it quietly does nothing. Use `.remove()` if you want an error when the element is missing (so you know something went wrong)."}', 6);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-3-3', 'course-python-level-2', 'chap-pyl2-03', 'lesson-pyl2-3-3', 3, 'Choosing the Right Data Structure', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-3-3-dialogue', 'lesson-pyl2-3-3', 'dialogue', '{"shady": "Now I know four different structures. When do I use which? They all seem to store data. Those four questions pick the structure?", "cody": "Ask yourself four questions: Does order matter? Will the data change? Do duplicates matter? Do I need to look things up by name? Pretty much. Let me map them out."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-3-3-concept', 'lesson-pyl2-3-3', 'concept', '{"title": "Lists, tuples, sets, and dictionaries each have a specific strength. Choosing the right one makes code cleaner and faster.", "body": "Given a scenario, the student selects the most appropriate data structure and explains why."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-3-3-showcase', 'lesson-pyl2-3-3', 'showcase', '{"title": "Example", "language": "Python", "code": "# \\u2705 List \\u2014 ordered, changeable, duplicates fine\\ndaily_temperatures = [29, 31, 28, 33, 30, 29]\\n\\n# \\u2705 Tuple \\u2014 fixed, coordinates shouldn''t change\\ncairo_location = (30.0444, 31.2357)\\n\\n# \\u2705 Set \\u2014 unique usernames, fast membership check\\nregistered_users = {\\"ahmed\\", \\"sara\\", \\"omar\\"}\\n\\n# \\u2705 Dictionary \\u2014 look up data by a name/key\\nstudent_profiles = {\\n    \\"S001\\": {\\"name\\": \\"Ahmed\\", \\"score\\": 95},\\n    \\"S002\\": {\\"name\\": \\"Sara\\",  \\"score\\": 88}\\n}", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-3-3-playground', 'lesson-pyl2-3-3', 'playground', '{"title": "Playground", "language": "Python", "code": "# Scenario: A quiz leaderboard system\\n# - Scores can change (player improves) \\u2192 dict or list\\n# - Players are unique \\u2192 dict keyed by name\\n# - Order of scores matters (rank) \\u2192 sorted list when displaying\\n\\nleaderboard = {}   # name \\u2192 best_score\\n\\ndef record_score(name, score):\\n    current_best = leaderboard.get(name, 0)\\n    if score > current_best:\\n        leaderboard[name] = score\\n        print(f\\"  New best for {name}: {score}\\")\\n    else:\\n        print(f\\"  {name}''s current best ({current_best}) is still higher.\\")\\n\\nrecord_score(\\"Ahmed\\", 85)\\nrecord_score(\\"Sara\\", 92)\\nrecord_score(\\"Ahmed\\", 78)    # lower \\u2014 won''t update\\nrecord_score(\\"Ahmed\\", 90)    # higher \\u2014 updates\\n\\n# Print ranked leaderboard\\nprint(\\"\\\\n=== Leaderboard ===\\")\\nranked = sorted(leaderboard.items(), key=lambda x: x[1], reverse=True)\\nfor rank, (name, score) in enumerate(ranked, 1):\\n    print(f\\"  #{rank}  {name:<15} {score}\\")", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-3-3-challenge', 'lesson-pyl2-3-3', 'exercise', '{"title": "Mission", "instruction": "For each scenario below, choose the best data structure and write 3 lines of code using it:\\n1. Store the months of the year (fixed, ordered)\\n2. Track which students have submitted their assignment (unique, fast check)\\n3. Store each student''s name \\u2192 their list of test scores\\n4. Keep a log of website visits (ordered, duplicates expected)", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-3-3-quiz', 'lesson-pyl2-3-3', 'quiz', '{"question": "You need to store 1000 allowed email domains and check very quickly whether a domain is allowed. Which structure is best?", "code": "", "options": [{"id": "A", "text": "List \\u2014 because it''s ordered"}, {"id": "B", "text": "Tuple \\u2014 because the domains are fixed"}, {"id": "C", "text": "Set  \\u2014 because `in` on a set is near-instant, even with millions of items"}, {"id": "D", "text": "Dictionary \\u2014 because you need key-value pairs"}], "correct": "C", "explanation": "Set membership (`x in set`) is O(1) \\u2014 near-instant regardless of size. `x in list` checks every item one by one \\u2014 O(n). For fast membership testing with no duplicates, set is the right choice."}', 6);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-3-4', 'course-python-level-2', 'chap-pyl2-03', 'lesson-pyl2-3-4', 4, 'Mini Project — Attendance and Roster System', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-3-4-dialogue', 'lesson-pyl2-3-4', 'dialogue', '{"shady": "Can we make something where sets and dictionaries actually work together? I want to see them both doing real work. That''s actually something my school needs.", "cody": "How about an attendance system? A dictionary holds all students \\u2014 the full roster. Each day''s attendance is a set \\u2014 automatically no duplicates. At the end of the week, we do set operations to find perfect attendance, frequent absences, that kind of thing. Most useful programs start that way."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-3-4-concept', 'lesson-pyl2-3-4', 'concept', '{"title": "Use sets and dictionaries together to build a real attendance tracking system.", "body": "The student builds a multi-day attendance system using sets for per-day attendance and a dictionary for the full roster."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-3-4-showcase', 'lesson-pyl2-3-4', 'showcase', '{"title": "Example", "language": "Python", "code": "# Full roster (dictionary: ID \\u2192 name)\\nroster = {\\n    \\"S01\\": \\"Ahmed\\", \\"S02\\": \\"Sara\\",  \\"S03\\": \\"Omar\\",\\n    \\"S04\\": \\"Nour\\",  \\"S05\\": \\"Ali\\",   \\"S06\\": \\"Maya\\",\\n    \\"S07\\": \\"Karim\\", \\"S08\\": \\"Layla\\"\\n}\\n\\n# Daily attendance sets (who was present each day)\\nsunday    = {\\"S01\\", \\"S02\\", \\"S03\\", \\"S04\\", \\"S05\\"}\\nmonday    = {\\"S01\\", \\"S02\\", \\"S04\\", \\"S06\\", \\"S07\\"}\\ntuesday   = {\\"S02\\", \\"S03\\", \\"S04\\", \\"S05\\", \\"S08\\"}\\nwednesday = {\\"S01\\", \\"S02\\", \\"S04\\", \\"S05\\", \\"S06\\"}\\nthursday  = {\\"S01\\", \\"S02\\", \\"S03\\", \\"S04\\", \\"S05\\", \\"S07\\"}\\n\\nall_days = [sunday, monday, tuesday, wednesday, thursday]\\nall_ids  = set(roster.keys())\\n\\ndef name(sid):\\n    return roster.get(sid, sid)\\n\\n# Perfect attendance \\u2014 present ALL 5 days\\nperfect = sunday & monday & tuesday & wednesday & thursday\\nprint(\\"Perfect attendance:\\")\\nfor sid in perfect:\\n    print(f\\"  {name(sid)}\\")\\n\\n# Never attended \\u2014 absent all 5 days\\nnever_came = all_ids - (sunday | monday | tuesday | wednesday | thursday)\\nprint(\\"\\\\nNever attended:\\")\\nfor sid in never_came:\\n    print(f\\"  {name(sid)}\\")\\n\\n# Attendance count per student\\nprint(\\"\\\\nAttendance summary:\\")\\nprint(f\\"  {''Name'':<12} {''Days'':>5}\\")\\nprint(\\"  \\" + \\"-\\" * 18)\\nfor sid in sorted(roster):\\n    count = sum(1 for day in all_days if sid in day)\\n    bar = \\"\\u2593\\" * count + \\"\\u2591\\" * (5 - count)\\n    print(f\\"  {name(sid):<12} {count:>2}/5  {bar}\\")", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-3-4-playground', 'lesson-pyl2-3-4', 'playground', '{"title": "Playground", "language": "Python", "code": "roster = {\\"S01\\": \\"Ahmed\\", \\"S02\\": \\"Sara\\", \\"S03\\": \\"Omar\\", \\"S04\\": \\"Nour\\"}\\n\\n# Record today''s attendance interactively\\nprint(\\"Mark attendance (enter student IDs, empty line to finish):\\")\\ntoday_present = set()\\nwhile True:\\n    sid = input(\\"ID: \\").strip().upper()\\n    if not sid:\\n        break\\n    if sid in roster:\\n        today_present.add(sid)\\n        print(f\\"  \\u2714 {roster[sid]} marked present\\")\\n    else:\\n        print(f\\"  \\u2718 ID ''{sid}'' not in roster\\")\\n\\n# Who was absent?\\ntoday_absent = set(roster.keys()) - today_present\\n\\nprint(f\\"\\\\nPresent ({len(today_present)}):\\", \\", \\".join(roster[s] for s in today_present))\\nprint(f\\"Absent  ({len(today_absent)}):\\",  \\", \\".join(roster[s] for s in today_absent))", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-3-4-challenge', 'lesson-pyl2-3-4', 'exercise', '{"title": "Mission", "instruction": "Extend the system so it also:\\n1. Asks for a second day''s attendance\\n2. Prints who attended BOTH days\\n3. Prints who attended EITHER day (or both)\\n4. Prints who attended day 1 but was absent day 2", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-3-4-quiz', 'lesson-pyl2-3-4', 'quiz', '{"question": "In the attendance system, why is each day''s attendance stored as a `set` rather than a `list`?", "code": "", "options": [{"id": "A", "text": "Sets are faster to create than lists"}, {"id": "B", "text": "Sets prevent a student being marked present twice, and set operations (& | -) work directly"}, {"id": "C", "text": "Sets are easier to print"}, {"id": "D", "text": "Lists can''t store strings"}], "correct": "B", "explanation": "Sets guarantee uniqueness (can''t accidentally mark someone twice) and enable clean set math: `day1 & day2` for who attended both, `day1 | day2` for either, `all_ids - day1` for absences \\u2014 no loops needed."}', 6);

INSERT INTO exams (id, course_id, chapter_id, title, pass_threshold, exam_type)
VALUES ('exam-pyl2-ch03', 'course-python-level-2', 'chap-pyl2-03', 'Chapter 3 Exam', 60, 'chapter');
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch03-01', 'exam-pyl2-ch03', '`t = (1, 2, 3)`. What happens if you run `t[0] = 99`?', 'MCQ', '[{"id": "A", "text": "`t` becomes `(99, 2, 3)`  B) `TypeError`"}]', 'A', '', 1);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch03-02', 'exam-pyl2-ch03', '`s = set()`. Which correctly adds "hello" to the set?', 'MCQ', '[{"id": "A", "text": "`s["}]', 'A', '', 2);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch03-03', 'exam-pyl2-ch03', '`{1,2,3} & {2,3,4,5}` returns:', 'MCQ', '[{"id": "A", "text": "`{1,2,3,4,5}`  B) `{1,4,5}`  C) `{2,3}`"}]', 'A', '', 3);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch03-04', 'exam-pyl2-ch03', 'You need to store 5 configuration values that must never change during the program. Which is most appropriate?', 'MCQ', '[{"id": "A", "text": "List  B) Dictionary  C) Set  D) Tuple"}]', 'A', '', 4);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch03-05', 'exam-pyl2-ch03', 'Write a function `unique_chars(word)` that returns a **set** of unique characters in the word, then write another function `shared_chars(word1, word2)` that returns characters appearing in **both** words using a single set operation. Example: `shared_chars("python", "typhoon")` → `{''t'', ''y'', ''o'', ''n''}`.

---

---', 'Coding', '[]', 'A', '', 5);

INSERT INTO chapters (id, course_id, slug, chapter_number, title, description)
VALUES ('chap-pyl2-04', 'course-python-level-2', 'file-io', 4, 'Working with Files — File I/O', 'Real programs save data permanently. Students learn to read and write text files.');

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-4-1', 'course-python-level-2', 'chap-pyl2-04', 'lesson-pyl2-4-1', 1, 'Reading Files', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-4-1-dialogue', 'lesson-pyl2-4-1', 'dialogue', '{"shady": "My program asks users for student names every time it starts. They have to re-type everything. It''s so annoying. But how does Python read a file? Why always ''with''?", "cody": "You need to save them to a file. Then on the next run, read the file and load them automatically. With the open() function. You give it a filename and a mode \\u2014 ''r'' for read, ''w'' for write. And you always use the ''with'' keyword to open files. Because ''with'' automatically closes the file when you''re done \\u2014 even if something goes wrong. Without it, files can get corrupted."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-4-1-concept', 'lesson-pyl2-4-1', 'concept', '{"title": "Python can open and read text files. The `with` statement ensures files are always properly closed.", "body": "The student reads a file''s contents using `.read()` and `.readlines()`, and understands why `with` is important."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-4-1-showcase', 'lesson-pyl2-4-1', 'showcase', '{"title": "Example", "language": "Python", "code": "# Assume \\"students.txt\\" contains:\\n# Ahmed\\n# Sara\\n# Omar\\n\\n# .read() \\u2014 reads the ENTIRE file as one string\\nwith open(\\"students.txt\\", \\"r\\") as f:\\n    content = f.read()\\nprint(content)\\n# Ahmed\\n# Sara\\n# Omar\\n\\n# .readlines() \\u2014 reads into a LIST, one item per line\\nwith open(\\"students.txt\\", \\"r\\") as f:\\n    lines = f.readlines()\\nprint(lines)\\n# [''Ahmed\\\\n'', ''Sara\\\\n'', ''Omar\\\\n'']   \\u2190 note the \\\\n at the end of each!\\n\\n# Clean: strip the \\\\n from each line\\nwith open(\\"students.txt\\", \\"r\\") as f:\\n    lines = [line.strip() for line in f.readlines()]\\nprint(lines)\\n# [''Ahmed'', ''Sara'', ''Omar'']", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-4-1-playground', 'lesson-pyl2-4-1', 'playground', '{"title": "Playground", "language": "Python", "code": "# First, let''s create a sample file to read:\\nimport os\\n\\n# Create a sample file\\nwith open(\\"sample.txt\\", \\"w\\") as f:\\n    f.write(\\"Line one\\\\nLine two\\\\nLine three\\\\nLine four\\\\n\\")\\n\\nprint(\\"File created.\\\\n\\")\\n\\n# Now read it back:\\nprint(\\"=== Using .read() ===\\")\\nwith open(\\"sample.txt\\", \\"r\\") as f:\\n    everything = f.read()\\nprint(everything)\\n\\nprint(\\"=== Using .readlines() ===\\")\\nwith open(\\"sample.txt\\", \\"r\\") as f:\\n    lines = f.readlines()\\nfor i, line in enumerate(lines, 1):\\n    print(f\\"Line {i}: {line.strip()!r}\\")\\n\\n# TODO: Count how many lines the file has\\n# TODO: Print only lines that contain the letter ''o''", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-4-1-challenge', 'lesson-pyl2-4-1', 'exercise', '{"title": "Mission", "instruction": "1. Create a file called \\"my_data.txt\\" with 5 lines \\u2014 each line is a fruit name\\n   (you can write this file manually or use Python to create it \\u2014 see the playground)\\n2. Read the file and print each fruit with its line number: \\"1. Apple\\"\\n3. Count how many fruits start with a vowel\\n4. Print the fruits in alphabetical order (read into a list, sort, then print)", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-4-1-quiz', 'lesson-pyl2-4-1', 'quiz', '{"question": "Why should you always use `with open(...) as f:` instead of just `f = open(...)`?", "code": "", "options": [{"id": "A", "text": "`with` is faster than `open()`"}, {"id": "B", "text": "`with` automatically closes the file when the block ends \\u2014 even if an error occurs"}, {"id": "C", "text": "`open()` only works inside `with` blocks"}, {"id": "D", "text": "`with` can read multiple files at once"}], "correct": "B", "explanation": "The `with` statement is a context manager. It guarantees the file is closed when the block exits \\u2014 whether it exits normally or with an exception. Unclosed files can cause data loss or corruption."}', 6);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-4-2', 'course-python-level-2', 'chap-pyl2-04', 'lesson-pyl2-4-2', 2, 'Writing and Appending to Files', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-4-2-dialogue', 'lesson-pyl2-4-2', 'dialogue', '{"shady": "I built a score tracker! But every time I restart the program, all the scores disappear. How? And if I run the program again with ''w'' \\u2014 do my old scores survive? So I should use ''a'' for the score tracker.", "cody": "Because they''re only in memory \\u2014 RAM clears when the program ends. You need to write them to a file. Change the mode from ''r'' to ''w''. ''w'' means write. No. That''s the most dangerous thing about ''w'' mode. It ERASES the file and starts fresh every time. If you want to ADD to existing content, use ''a'' for append. Exactly. ''a'' adds to the end without touching what''s already there."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-4-2-concept', 'lesson-pyl2-4-2', 'concept', '{"title": "Mode `\\"w\\"` creates or overwrites a file. Mode `\\"a\\"` adds to the end without erasing existing content.", "body": "The student writes data to files and appends new data correctly, understanding the difference between `\\"w\\"` and `\\"a\\"`."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-4-2-showcase', 'lesson-pyl2-4-2', 'showcase', '{"title": "Example", "language": "Python", "code": "# Creates \\"scores.txt\\" if it doesn''t exist\\n# \\u26a0 OVERWRITES it completely if it does exist!\\nwith open(\\"scores.txt\\", \\"w\\") as f:\\n    f.write(\\"Ahmed: 95\\\\n\\")\\n    f.write(\\"Sara: 88\\\\n\\")\\n    f.write(\\"Omar: 72\\\\n\\")\\n\\n# Each .write() call needs \\\\n if you want a new line \\u2014 it''s not added automatically", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-4-2-playground', 'lesson-pyl2-4-2', 'playground', '{"title": "Playground", "language": "Python", "code": "# Persistent session log \\u2014 every time you run this, it adds to the log\\nimport datetime\\n\\nLOG_FILE = \\"session_log.txt\\"\\n\\ntimestamp = datetime.datetime.now().strftime(\\"%Y-%m-%d %H:%M:%S\\")\\n\\nwith open(LOG_FILE, \\"a\\") as f:\\n    f.write(f\\"[{timestamp}] Session started\\\\n\\")\\n\\nname = input(\\"Your name: \\")\\n\\nwith open(LOG_FILE, \\"a\\") as f:\\n    f.write(f\\"[{timestamp}] User: {name}\\\\n\\")\\n    f.write(f\\"[{timestamp}] Session ended\\\\n\\\\n\\")\\n\\n# Read and display the full log\\nprint(\\"\\\\n=== Full Log ===\\")\\nwith open(LOG_FILE, \\"r\\") as f:\\n    print(f.read())", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-4-2-challenge', 'lesson-pyl2-4-2', 'exercise', '{"title": "Mission", "instruction": "1. Create a \\"diary.txt\\" file\\n2. Ask the user to enter today''s note (one line of text)\\n3. Append it to the file with today''s date as a label\\n   Format: \\"2024-03-15: I learned about file writing today.\\"\\n4. After appending, read the full file and print all entries\\n5. Run the program 3 times \\u2014 verify that entries accumulate, not overwrite", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-4-2-quiz', 'lesson-pyl2-4-2', 'quiz', '{"question": "You open a file with `\\"w\\"` mode that already has 500 lines of important data. What happens?", "code": "", "options": [{"id": "A", "text": "Python appends to the end of the existing data"}, {"id": "B", "text": "Python raises a FileExistsError"}, {"id": "C", "text": "The existing 500 lines are permanently erased, and the file starts empty"}, {"id": "D", "text": "Python asks you to confirm before overwriting"}], "correct": "C", "explanation": "Mode `\\"w\\"` immediately truncates (empties) the file before writing. There is no warning and no undo. Always use `\\"a\\"` when you want to preserve existing content."}', 6);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-4-3', 'course-python-level-2', 'chap-pyl2-04', 'lesson-pyl2-4-3', 3, 'Reading Structured Data from Files', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-4-3-dialogue', 'lesson-pyl2-4-3', 'dialogue', '{"shady": "I want to save my grade book to a file \\u2014 not just names, but names AND scores together. Like a spreadsheet?", "cody": "You store structured data \\u2014 multiple fields per record. A common way is CSV: Comma-Separated Values. Each line is one record. Commas separate the fields. Exactly like a spreadsheet, but in plain text. Python has a csv module for this properly, but let''s start by doing it manually \\u2014 so you understand what''s happening."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-4-3-concept', 'lesson-pyl2-4-3', 'concept', '{"title": "Files can store structured records (like CSV) that you parse back into usable data structures.", "body": "The student writes structured records to a file and reads them back into a list of dictionaries."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-4-3-showcase', 'lesson-pyl2-4-3', 'showcase', '{"title": "Example", "language": "Python", "code": "students = [\\n    {\\"name\\": \\"Ahmed\\", \\"grade\\": 10, \\"score\\": 95},\\n    {\\"name\\": \\"Sara\\",  \\"grade\\": 11, \\"score\\": 88},\\n    {\\"name\\": \\"Omar\\",  \\"grade\\": 10, \\"score\\": 72},\\n]\\n\\nwith open(\\"students.csv\\", \\"w\\") as f:\\n    # Write header line first\\n    f.write(\\"name,grade,score\\\\n\\")\\n    for s in students:\\n        f.write(f\\"{s[''name'']},{s[''grade'']},{s[''score'']}\\\\n\\")", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-4-3-playground', 'lesson-pyl2-4-3', 'playground', '{"title": "Playground", "language": "Python", "code": "import csv\\n\\nFILENAME = \\"gradebook.csv\\"\\n\\ndef save_students(students):\\n    with open(FILENAME, \\"w\\", newline=\\"\\") as f:\\n        writer = csv.DictWriter(f, fieldnames=[\\"name\\", \\"score\\"])\\n        writer.writeheader()\\n        writer.writerows(students)\\n    print(f\\"Saved {len(students)} students to {FILENAME}\\")\\n\\ndef load_students():\\n    students = []\\n    try:\\n        with open(FILENAME, \\"r\\") as f:\\n            reader = csv.DictReader(f)\\n            for row in reader:\\n                row[\\"score\\"] = int(row[\\"score\\"])\\n                students.append(row)\\n    except FileNotFoundError:\\n        print(\\"No saved file found.\\")\\n    return students\\n\\n# Test it:\\ndata = [\\n    {\\"name\\": \\"Ahmed\\", \\"score\\": 95},\\n    {\\"name\\": \\"Sara\\",  \\"score\\": 88},\\n]\\nsave_students(data)\\nloaded = load_students()\\nfor s in loaded:\\n    print(f\\"{s[''name'']}: {s[''score'']}\\")", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-4-3-challenge', 'lesson-pyl2-4-3', 'exercise', '{"title": "Mission", "instruction": "1. Create a file \\"inventory.csv\\" with columns: item, quantity, price\\n2. Add 5 products manually (write them line by line)\\n3. Read the file back and calculate:\\n   a. The total value of all inventory (sum of quantity \\u00d7 price for each item)\\n   b. The most expensive item\\n   c. Items where quantity < 5 (need restocking)", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-4-3-quiz', 'lesson-pyl2-4-3', 'quiz', '{"question": "You read a line `\\"Ahmed,10,95\\\\n\\"` from a CSV file and split it. What is `parts[1]` and what type is it?", "code": "", "options": [{"id": "A", "text": "`10` (integer)"}, {"id": "B", "text": "`\\"10\\"` (string)"}, {"id": "C", "text": "`10.0` (float)"}, {"id": "D", "text": "`None`"}], "correct": "B", "explanation": "`.split(\\",\\")` returns a list of **strings** \\u2014 always. Even though `\\"10\\"` looks like a number, it is a string until you convert it with `int(\\"10\\")`. Always convert after reading from a file."}', 6);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-4-4', 'course-python-level-2', 'chap-pyl2-04', 'lesson-pyl2-4-4', 4, 'Mini Project — Persistent Score Tracker', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-4-4-dialogue', 'lesson-pyl2-4-4', 'dialogue', '{"shady": "I want a leaderboard. You run the program, add your score, and even when you quit and come back later, the scores from last time are still there. Load \\u2192 Work \\u2192 Save. That''s the pattern?", "cody": "That''s a persistent application \\u2014 data that outlives the program. You load from the file at startup. You work in memory. You save back to the file when you''re done. That''s the pattern. For almost every program that stores data."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-4-4-concept', 'lesson-pyl2-4-4', 'concept', '{"title": "Combine file I/O with dictionaries and user interaction to build a program whose data survives between runs.", "body": "The student builds a score tracker that loads data on start, accepts new scores, and saves everything on exit."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-4-4-showcase', 'lesson-pyl2-4-4', 'showcase', '{"title": "Example", "language": "Python", "code": "import csv\\nimport os\\n\\nSCORES_FILE = \\"leaderboard.csv\\"\\n\\n# \\u2500\\u2500 File operations \\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\ndef load_scores():\\n    scores = {}\\n    if not os.path.exists(SCORES_FILE):\\n        return scores\\n    with open(SCORES_FILE, \\"r\\") as f:\\n        reader = csv.reader(f)\\n        for row in reader:\\n            if len(row) == 2:\\n                name, score = row\\n                scores[name] = int(score)\\n    return scores\\n\\ndef save_scores(scores):\\n    with open(SCORES_FILE, \\"w\\", newline=\\"\\") as f:\\n        writer = csv.writer(f)\\n        for name, score in scores.items():\\n            writer.writerow([name, score])\\n\\n# \\u2500\\u2500 Display \\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\ndef show_leaderboard(scores, top_n=5):\\n    if not scores:\\n        print(\\"  No scores yet.\\")\\n        return\\n    ranked = sorted(scores.items(), key=lambda x: x[1], reverse=True)\\n    print(f\\"\\\\n{''\\u2550''*28}\\")\\n    print(f\\"{''  LEADERBOARD'':^28}\\")\\n    print(f\\"{''\\u2550''*28}\\")\\n    medals = [\\"\\ud83e\\udd47\\", \\"\\ud83e\\udd48\\", \\"\\ud83e\\udd49\\"]\\n    for i, (name, score) in enumerate(ranked[:top_n]):\\n        medal = medals[i] if i < 3 else f\\"#{i+1}\\"\\n        print(f\\"  {medal}  {name:<14} {score:>5}\\")\\n    print(f\\"{''\\u2550''*28}\\\\n\\")\\n\\n# \\u2500\\u2500 Main \\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\ndef main():\\n    scores = load_scores()\\n    print(\\"=== Score Tracker ===\\")\\n    print(f\\"Loaded {len(scores)} existing scores.\\\\n\\")\\n\\n    while True:\\n        print(\\"1. Add score   2. Leaderboard   3. Clear mine   4. Quit\\")\\n        choice = input(\\"Choice: \\").strip()\\n\\n        if choice == \\"1\\":\\n            name  = input(\\"Your name: \\").strip()\\n            score = int(input(\\"Your score: \\"))\\n            if name in scores:\\n                if score > scores[name]:\\n                    print(f\\"  New personal best! {scores[name]} \\u2192 {score}\\")\\n                    scores[name] = score\\n                else:\\n                    print(f\\"  Your best is still {scores[name]}. Keep trying!\\")\\n            else:\\n                scores[name] = score\\n                print(f\\"  Welcome, {name}! Score: {score}\\")\\n\\n        elif choice == \\"2\\":\\n            show_leaderboard(scores)\\n\\n        elif choice == \\"3\\":\\n            name = input(\\"Your name: \\").strip()\\n            if name in scores:\\n                del scores[name]\\n                print(f\\"  {name} removed.\\")\\n            else:\\n                print(f\\"  ''{name}'' not found.\\")\\n\\n        elif choice == \\"4\\":\\n            save_scores(scores)\\n            print(f\\"Scores saved. Goodbye!\\")\\n            break\\n        else:\\n            print(\\"  Invalid choice.\\")\\n\\nmain()", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-4-4-playground', 'lesson-pyl2-4-4', 'playground', '{"title": "Playground", "language": "Python", "code": "# Simplified version to get started\\nFILENAME = \\"my_scores.csv\\"\\n\\ndef load():\\n    data = {}\\n    try:\\n        with open(FILENAME) as f:\\n            for line in f:\\n                parts = line.strip().split(\\",\\")\\n                if len(parts) == 2:\\n                    data[parts[0]] = int(parts[1])\\n    except FileNotFoundError:\\n        pass\\n    return data\\n\\ndef save(data):\\n    with open(FILENAME, \\"w\\") as f:\\n        for name, score in data.items():\\n            f.write(f\\"{name},{score}\\\\n\\")\\n\\nscores = load()\\nname  = input(\\"Name: \\")\\nscore = int(input(\\"Score: \\"))\\nscores[name] = max(scores.get(name, 0), score)\\nsave(scores)\\n\\nprint(\\"\\\\nAll scores:\\")\\nfor n, s in sorted(scores.items(), key=lambda x: x[1], reverse=True):\\n    print(f\\"  {n}: {s}\\")", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-4-4-challenge', 'lesson-pyl2-4-4', 'exercise', '{"title": "Mission", "instruction": "Extend the persistent score tracker:\\n1. Add a \\"reset all\\" option that empties the leaderboard and deletes the file\\n2. Show the date each score was set \\u2014 save date alongside name and score in the CSV\\n   Hint: use datetime.date.today() (Chapter 5)\\n3. Add a \\"top 3 only\\" display that shows just the medal positions", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-4-4-quiz', 'lesson-pyl2-4-4', 'quiz', '{"question": "In the score tracker, why do we load the file at the START and save at the END, rather than saving after every single change?", "code": "", "options": [{"id": "A", "text": "Saving mid-program causes errors"}, {"id": "B", "text": "It''s simpler and faster \\u2014 disk I/O is slow and doing it once is more efficient"}, {"id": "C", "text": "Python doesn''t allow saving during a loop"}, {"id": "D", "text": "The file would get corrupted if saved multiple times"}], "correct": "B", "explanation": "Disk I/O (reading and writing files) is much slower than working in memory. Load once into a dictionary, work in memory (fast), save once at the end (one disk write). This is the standard pattern."}', 6);

INSERT INTO exams (id, course_id, chapter_id, title, pass_threshold, exam_type)
VALUES ('exam-pyl2-ch04', 'course-python-level-2', 'chap-pyl2-04', 'Chapter 4 Exam', 60, 'chapter');
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch04-01', 'exam-pyl2-ch04', 'What does `open("data.txt", "w")` do if "data.txt" already exists?', 'MCQ', '[{"id": "A", "text": "Appends to the end  B) Raises an error  C) Erases the file and starts empty"}]', 'A', '', 1);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch04-02', 'exam-pyl2-ch04', '`f.readlines()` returns:', 'MCQ', '[{"id": "A", "text": "A single string  B) A list of strings, one per line"}]', 'A', '', 2);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch04-03', 'exam-pyl2-ch04', 'Why does every line read from a file need `.strip()`?', 'MCQ', '[{"id": "A", "text": "To convert it from bytes  B) To remove the invisible `\\\\n` at the end"}]', 'A', '', 3);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch04-04', 'exam-pyl2-ch04', 'You want to add today''s log entry without erasing yesterday''s. Which mode?', 'MCQ', '[{"id": "A", "text": "`"}]', 'A', '', 4);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch04-05', 'exam-pyl2-ch04', 'Write a function `count_words_in_file(filename)` that opens a text file and returns the total number of words across all lines. If the file doesn''t exist, return 0. Test it by creating a short text file first.

---

---', 'Coding', '[]', 'A', '', 5);

INSERT INTO chapters (id, course_id, slug, chapter_number, title, description)
VALUES ('chap-pyl2-05', 'course-python-level-2', 'modules-standard-library', 5, 'Modules and the Standard Library', 'Python comes with hundreds of ready-made modules. Students learn to import and use the most valuable ones.');

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-5-1', 'course-python-level-2', 'chap-pyl2-05', 'lesson-pyl2-5-1', 1, 'Importing Modules — math', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-5-1-dialogue', 'lesson-pyl2-5-1', 'dialogue', '{"shady": "I need to calculate the hypotenuse of a right triangle. That means I need square root. Does Python have that? Module? Where is it? And then I can use everything inside it?", "cody": "Yes \\u2014 but it''s not built in like print(). It''s in the math module. It came with Python \\u2014 already installed, waiting to be imported. Think of it like a toolbox in storage. import math brings that toolbox into your workspace. Everything. And Python has dozens of toolboxes like this."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-5-1-concept', 'lesson-pyl2-5-1', 'concept', '{"title": "A module is a file of ready-made functions. `import` makes them available in your program.", "body": "The student imports `math` in three styles and uses its most important functions."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-5-1-showcase', 'lesson-pyl2-5-1', 'showcase', '{"title": "Example", "language": "Python", "code": "# Style 1: import the whole module (most common)\\nimport math\\nprint(math.sqrt(16))     # 4.0\\nprint(math.pi)           # 3.141592653589793\\n\\n# Style 2: import specific items \\u2014 no prefix needed\\nfrom math import sqrt, pi, ceil, floor\\nprint(sqrt(25))          # 5.0\\nprint(pi)                # 3.141592...\\n\\n# Style 3: import with alias \\u2014 for long module names\\nimport math as m\\nprint(m.sqrt(9))         # 3.0", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-5-1-playground', 'lesson-pyl2-5-1', 'playground', '{"title": "Playground", "language": "Python", "code": "import math\\n\\n# Geometry toolkit\\nprint(\\"=== Geometry Calculator ===\\\\n\\")\\n\\n# 1. Circle\\nr = float(input(\\"Circle radius: \\"))\\nprint(f\\"  Area:        {math.pi * r**2:.4f}\\")\\nprint(f\\"  Perimeter:   {2 * math.pi * r:.4f}\\")\\n\\n# 2. Right triangle\\nprint()\\na = float(input(\\"Triangle \\u2014 side a: \\"))\\nb = float(input(\\"Triangle \\u2014 side b: \\"))\\nc = math.sqrt(a**2 + b**2)\\nprint(f\\"  Hypotenuse:  {c:.4f}\\")\\nprint(f\\"  Perimeter:   {a + b + c:.4f}\\")\\nprint(f\\"  Area:        {0.5 * a * b:.4f}\\")\\n\\n# TODO: Add a square calculator (diagonal = side \\u00d7 \\u221a2)\\n# TODO: Add a cylinder volume calculator (\\u03c0 \\u00d7 r\\u00b2 \\u00d7 height)", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-5-1-challenge', 'lesson-pyl2-5-1', 'exercise', '{"title": "Mission", "instruction": "Write a function that takes three sides of a triangle (a, b, c) and:\\n1. Checks if they can form a valid triangle (each side must be less than the sum of the other two)\\n2. If valid, calculate the area using Heron''s formula:\\n   s = (a + b + c) / 2\\n   area = math.sqrt(s * (s-a) * (s-b) * (s-c))\\n3. Print the area with 2 decimal places", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-5-1-quiz', 'lesson-pyl2-5-1', 'quiz', '{"question": "What is the difference between `import math` and `from math import sqrt`?", "code": "", "options": [{"id": "A", "text": "`from math import sqrt` is faster to execute"}, {"id": "B", "text": "With `import math` you write `math.sqrt()`. With `from math import sqrt` you write just `sqrt()`."}, {"id": "C", "text": "`from math import sqrt` imports ALL math functions"}, {"id": "D", "text": "They are completely identical"}], "correct": "B", "explanation": "Both give you the `sqrt` function. The difference is in how you call it. `import math` keeps functions in the `math` namespace so you write `math.sqrt()`. `from math import sqrt` brings `sqrt` directly into your namespace, so you write just `sqrt()`."}', 6);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-5-2', 'course-python-level-2', 'chap-pyl2-05', 'lesson-pyl2-5-2', 2, 'The random Module', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-5-2-dialogue', 'lesson-pyl2-5-2', 'dialogue', '{"shady": "I want to make a fair lottery for the class \\u2014 pick 3 random winners from 30 students. What if I just want one random item? Is it truly random?", "cody": "Perfect job for the random module. random.sample() picks multiple unique items from a list. random.choice(). One item from a sequence. And for random integers \\u2014 random.randint(). Pseudo-random \\u2014 good enough for games and lotteries. Not cryptographically secure, but fine for our purposes."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-5-2-concept', 'lesson-pyl2-5-2', 'concept', '{"title": "The `random` module generates pseudo-random numbers, picks random items, and shuffles sequences.", "body": "The student uses `random.randint()`, `random.choice()`, `random.shuffle()`, and `random.sample()` to build interactive programs."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-5-2-showcase', 'lesson-pyl2-5-2', 'showcase', '{"title": "Example", "language": "Python", "code": "import random\\n\\n# Random integer (inclusive on both ends)\\ndice = random.randint(1, 6)\\nprint(f\\"Dice roll: {dice}\\")       # 1, 2, 3, 4, 5, or 6\\n\\n# Random float between 0.0 and 1.0\\nchance = random.random()\\nprint(f\\"Probability: {chance:.4f}\\")\\n\\n# Random float in a range\\ntemp = random.uniform(20.0, 40.0)\\nprint(f\\"Temperature: {temp:.1f}\\u00b0C\\")\\n\\n# Random choice from a sequence\\nfruits = [\\"apple\\", \\"banana\\", \\"mango\\", \\"grape\\"]\\npick = random.choice(fruits)\\nprint(f\\"Random fruit: {pick}\\")\\n\\n# Multiple unique picks (no repeats)\\nwinners = random.sample(fruits, 2)\\nprint(f\\"Two winners: {winners}\\")\\n\\n# Shuffle a list in place\\ncards = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]\\nrandom.shuffle(cards)\\nprint(f\\"Shuffled: {cards}\\")", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-5-2-playground', 'lesson-pyl2-5-2', 'playground', '{"title": "Playground", "language": "Python", "code": "import random\\n\\n# Number guessing game\\nprint(\\"=== Guess the Number ===\\")\\nprint(\\"I''m thinking of a number between 1 and 100.\\\\n\\")\\n\\nsecret = random.randint(1, 100)\\nattempts = 0\\nmax_attempts = 7\\n\\nwhile attempts < max_attempts:\\n    remaining = max_attempts - attempts\\n    guess = int(input(f\\"Guess ({remaining} attempts left): \\"))\\n    attempts += 1\\n\\n    if guess == secret:\\n        print(f\\"\\u2705 Correct! You got it in {attempts} attempt(s)!\\")\\n        break\\n    elif guess < secret:\\n        print(\\"  \\u2191 Too low!\\")\\n    else:\\n        print(\\"  \\u2193 Too high!\\")\\nelse:\\n    print(f\\"\\u274c Out of attempts! The number was {secret}.\\")", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-5-2-challenge', 'lesson-pyl2-5-2', 'exercise', '{"title": "Mission", "instruction": "1. Build a \\"student of the day\\" picker:\\n   - Store 10 student names in a list\\n   - Pick one randomly each day using random.choice()\\n2. Build a quiz randomiser:\\n   - Create a list of 5 questions (each a tuple: (question, answer))\\n   - Use random.shuffle() to randomise the order each time\\n   - Ask each question and check the answer", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-5-2-quiz', 'lesson-pyl2-5-2', 'quiz', '{"question": "What is the difference between `random.choice(lst)` and `random.sample(lst, 1)`?", "code": "", "options": [{"id": "A", "text": "No difference \\u2014 both return one random element"}, {"id": "B", "text": "`random.choice()` returns the element directly; `random.sample()` returns a **list** containing one element"}, {"id": "C", "text": "`random.sample()` is faster"}, {"id": "D", "text": "`random.choice()` can pick the same element twice"}], "correct": "B", "explanation": "`random.choice(lst)` returns the element itself: `\\"Ahmed\\"`. `random.sample(lst, 1)` returns a list: `[\\"Ahmed\\"]`. You''d need `[0]` to get the element from sample''s result."}', 6);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-5-3', 'course-python-level-2', 'chap-pyl2-05', 'lesson-pyl2-5-3', 3, 'The datetime Module', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-5-3-dialogue', 'lesson-pyl2-5-3', 'dialogue', '{"shady": "I want my score tracker to record when each score was set. And I want to show how many days until the end of the school year. What''s in it? Can I format dates the way I want them to look?", "cody": "Both are easy with the datetime module. Primarily two things you''ll use: datetime.date for working with just dates. datetime.datetime for both date and time. And timedelta for calculating differences \\u2014 how many days between two dates. Yes \\u2014 strftime() controls the format. I''ll show you."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-5-3-concept', 'lesson-pyl2-5-3', 'concept', '{"title": "The `datetime` module handles dates, times, and time calculations.", "body": "The student gets the current date/time, formats it, and calculates time differences."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-5-3-showcase', 'lesson-pyl2-5-3', 'showcase', '{"title": "Example", "language": "Python", "code": "import datetime\\n\\ntoday = datetime.date.today()\\nnow   = datetime.datetime.now()\\n\\nprint(today)     # 2024-09-15  (date only)\\nprint(now)       # 2024-09-15 14:32:07.123456  (date + time)\\n\\n# Access individual components\\nprint(today.year)     # 2024\\nprint(today.month)    # 9\\nprint(today.day)      # 15\\nprint(now.hour)       # 14\\nprint(now.minute)     # 32", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-5-3-playground', 'lesson-pyl2-5-3', 'playground', '{"title": "Playground", "language": "Python", "code": "import datetime\\n\\nprint(\\"=== Personal Date Calculator ===\\\\n\\")\\n\\n# How many days since the school year started?\\nschool_start = datetime.date(datetime.date.today().year, 9, 1)\\ntoday = datetime.date.today()\\ndays_in = (today - school_start).days\\nprint(f\\"School started:  {school_start.strftime(''%B %d, %Y'')}\\")\\nprint(f\\"Today:           {today.strftime(''%B %d, %Y'')}\\")\\nprint(f\\"Days of school:  {days_in}\\")\\n\\n# Countdown to end of year\\nyear_end = datetime.date(today.year, 12, 31)\\ndays_left = (year_end - today).days\\nprint(f\\"Days until year end: {days_left}\\")\\n\\n# TODO: Ask the user for their birthday, calculate their age in days and years", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-5-3-challenge', 'lesson-pyl2-5-3', 'exercise', '{"title": "Mission", "instruction": "1. Ask the user for their birthdate (format: DD/MM/YYYY)\\n2. Parse it with strptime\\n3. Calculate and print:\\n   a. Their age in complete years\\n   b. Their age in total days\\n   c. The day of the week they were born (strftime %A)\\n   d. How many days until their next birthday", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-5-3-quiz', 'lesson-pyl2-5-3', 'quiz', '{"question": "What does `datetime.timedelta(days=7)` represent?", "code": "", "options": [{"id": "A", "text": "The 7th day of the month"}, {"id": "B", "text": "7:00 AM exactly"}, {"id": "C", "text": "A duration of 7 days that can be added to or subtracted from a date"}, {"id": "D", "text": "The 7th month of the year"}], "correct": "C", "explanation": "`timedelta` represents a duration \\u2014 a difference between two dates. Adding `timedelta(days=7)` to a date gives you the date 7 days later. Subtracting two dates gives you a `timedelta`."}', 6);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-5-4', 'course-python-level-2', 'chap-pyl2-05', 'lesson-pyl2-5-4', 4, 'The os Module and Organising Imports', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-5-4-dialogue', 'lesson-pyl2-5-4', 'dialogue', '{"shady": "My program tries to open a file and crashes if it doesn''t exist. Is there a way to check before opening? os? I thought that was for operating system stuff.", "cody": "Yes \\u2014 os.path.exists(). It returns True or False before you ever try to open the file. It is \\u2014 and checking whether a file exists is exactly that kind of operating system interaction. The os module also helps you list folder contents, build file paths that work on any OS, and more."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-5-4-concept', 'lesson-pyl2-5-4', 'concept', '{"title": "The `os` module lets Python interact with the file system. Proper import style makes code readable and maintainable.", "body": "The student uses `os.path.exists()`, `os.listdir()`, `os.path.join()`, and follows Python import conventions."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-5-4-showcase', 'lesson-pyl2-5-4', 'showcase', '{"title": "Example", "language": "Python", "code": "import os\\n\\n# Does a file or folder exist?\\nprint(os.path.exists(\\"students.csv\\"))    # True or False\\nprint(os.path.isfile(\\"students.csv\\"))    # True only if it''s a file\\nprint(os.path.isdir(\\"data\\"))             # True only if it''s a folder\\n\\n# Get the current working directory\\nprint(os.getcwd())    # e.g. /home/shady/projects\\n\\n# List files in a folder\\nfiles = os.listdir(\\".\\")    # \\".\\" means current folder\\nfor f in files:\\n    print(f)", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-5-4-playground', 'lesson-pyl2-5-4', 'playground', '{"title": "Playground", "language": "Python", "code": "import os\\nimport datetime\\n\\n# File manager utility\\nDATA_FOLDER = \\"my_data\\"\\nos.makedirs(DATA_FOLDER, exist_ok=True)\\n\\ndef list_files():\\n    files = os.listdir(DATA_FOLDER)\\n    if not files:\\n        print(\\"  No files yet.\\")\\n    for f in files:\\n        path = os.path.join(DATA_FOLDER, f)\\n        size = os.path.getsize(path)\\n        print(f\\"  {f:<30} {size:>6} bytes\\")\\n\\ndef create_file(filename, content):\\n    path = os.path.join(DATA_FOLDER, filename)\\n    with open(path, \\"w\\") as f:\\n        f.write(content)\\n    print(f\\"  Created: {path}\\")\\n\\nprint(\\"Files in data folder:\\")\\nlist_files()\\nprint()\\ncreate_file(\\"note.txt\\", f\\"Created on {datetime.date.today()}\\\\nHello from Python!\\")\\nprint(\\"\\\\nAfter creating:\\")\\nlist_files()", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-5-4-challenge', 'lesson-pyl2-5-4', 'exercise', '{"title": "Mission", "instruction": "Build a \\"project setup\\" script that:\\n1. Creates a folder structure: my_project/data/, my_project/output/, my_project/logs/\\n2. Creates a \\"README.txt\\" in my_project/ with the creation date and a description\\n3. Lists all created folders to confirm they exist\\n4. Checks if \\"my_project/data/input.csv\\" exists \\u2014 if not, prints \\"input file missing\\"", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-5-4-quiz', 'lesson-pyl2-5-4', 'quiz', '{"question": "Why use `os.path.join(\\"folder\\", \\"file.txt\\")` instead of just `\\"folder/file.txt\\"`?", "code": "", "options": [{"id": "A", "text": "`os.path.join` is faster"}, {"id": "B", "text": "It automatically creates the folder if it doesn''t exist"}, {"id": "C", "text": "It builds the correct path separator (`/` or `\\\\`) for the current operating system"}, {"id": "D", "text": "Strings cannot contain `/` in Python"}], "correct": "C", "explanation": "Windows uses `\\\\` as a path separator; Mac and Linux use `/`. `os.path.join()` uses whatever is correct for the current OS, making your code work everywhere without changes."}', 6);

INSERT INTO exams (id, course_id, chapter_id, title, pass_threshold, exam_type)
VALUES ('exam-pyl2-ch05', 'course-python-level-2', 'chap-pyl2-05', 'Chapter 5 Exam', 60, 'chapter');
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch05-01', 'exam-pyl2-ch05', '`from math import sqrt, pi`. What does `print(sqrt(pi))` output?', 'MCQ', '[{"id": "A", "text": "Error \\u2014 can''t sqrt pi  B) `1.7724...`"}]', 'A', '', 1);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch05-02', 'exam-pyl2-ch05', '`random.sample(["a","b","c","d"], 3)` returns:', 'MCQ', '[{"id": "A", "text": "One random letter  B) Three letters \\u2014 possibly with repeats  C) Three **unique** letters from the list"}]', 'A', '', 2);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch05-03', 'exam-pyl2-ch05', 'What does `datetime.date.today().strftime("%A")` return?', 'MCQ', '[{"id": "A", "text": "The current time  B) The name of today''s day of the week"}]', 'A', '', 3);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch05-04', 'exam-pyl2-ch05', 'Which statement correctly checks whether "scores.csv" exists before opening it?', 'MCQ', '[{"id": "A", "text": "`if exists("}]', 'A', '', 4);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch05-05', 'exam-pyl2-ch05', 'Write a function `days_until_birthday(day, month)` that takes a birthday''s day and month, figures out the next occurrence of that birthday (might be this year or next), and returns the number of days until it. Use `datetime.date` and `timedelta`.

---

---', 'Coding', '[]', 'A', '', 5);

INSERT INTO chapters (id, course_id, slug, chapter_number, title, description)
VALUES ('chap-pyl2-06', 'course-python-level-2', 'error-handling', 6, 'When Things Go Wrong — Error Handling', 'Professional programs don''t crash — they handle errors gracefully. Students learn try/except to write resilient code.');

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-6-1', 'course-python-level-2', 'chap-pyl2-06', 'lesson-pyl2-6-1', 1, 'try and except — Catching Errors', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-6-1-dialogue', 'lesson-pyl2-6-1', 'dialogue', '{"shady": "My program crashed in front of the whole class. The user typed ''hello'' when I asked for a number. ValueError: invalid literal for int()... Like a safety net? Why don''t we just always use try/except on everything?", "cody": "That''s exactly why try/except exists. You ''try'' the risky code. If it fails, ''except'' catches the error \\u2014 and you handle it gracefully. Exactly. Without a net, one wrong input crashes everything. With a net, you catch the fall and keep going. Because it hides bugs. Use it only where you genuinely expect the code might fail for normal reasons \\u2014 user input, files, network."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-6-1-concept', 'lesson-pyl2-6-1', 'concept', '{"title": "Code inside `try` is \\"attempted\\". If it fails, `except` runs instead of crashing the program.", "body": "The student uses try/except to handle ValueError, ZeroDivisionError, and FileNotFoundError."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-6-1-showcase', 'lesson-pyl2-6-1', 'showcase', '{"title": "Example", "language": "Python", "code": "# \\u274c Without error handling \\u2014 crashes on bad input:\\nage = int(input(\\"Your age: \\"))    # user types \\"twenty\\" \\u2192 ValueError \\u2192 crash\\n\\n# \\u2705 With error handling:\\ntry:\\n    age = int(input(\\"Your age: \\"))\\n    print(f\\"You are {age} years old.\\")\\nexcept ValueError:\\n    print(\\"Please enter a valid number, not text.\\")", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-6-1-playground', 'lesson-pyl2-6-1', 'playground', '{"title": "Playground", "language": "Python", "code": "# Safe calculator \\u2014 handles all input errors\\ndef safe_divide(a, b):\\n    try:\\n        result = a / b\\n        return result\\n    except ZeroDivisionError:\\n        print(\\"Cannot divide by zero.\\")\\n        return None\\n\\ndef get_number(prompt):\\n    while True:\\n        try:\\n            return float(input(prompt))\\n        except ValueError:\\n            print(\\"  Please enter a valid number.\\")\\n\\nprint(\\"=== Safe Calculator ===\\")\\na = get_number(\\"First number: \\")\\nb = get_number(\\"Second number: \\")\\nresult = safe_divide(a, b)\\nif result is not None:\\n    print(f\\"{a} \\u00f7 {b} = {result:.4f}\\")", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-6-1-challenge', 'lesson-pyl2-6-1', 'exercise', '{"title": "Mission", "instruction": "Build an input-safe version of the grade calculator from Level 1:\\n1. Ask for 3 subject scores \\u2014 each score must be between 0 and 100\\n2. If the user types text, show an error and ask again (don''t crash)\\n3. If they enter a number outside 0-100, ask again\\n4. Calculate and display the average once all 3 valid scores are entered", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-6-1-quiz', 'lesson-pyl2-6-1', 'quiz', '{"question": "What is wrong with using a bare `except:` (no error type specified)?", "code": "", "options": [{"id": "A", "text": "It''s a syntax error"}, {"id": "B", "text": "It catches too much \\u2014 including system errors and keyboard interrupts \\u2014 hiding real problems"}, {"id": "C", "text": "It only catches TypeError"}, {"id": "D", "text": "Nothing \\u2014 it''s actually recommended"}], "correct": "B", "explanation": "`except:` with no type catches literally everything, including `SystemExit` and `KeyboardInterrupt`. This means your program won''t respond to Ctrl+C, and real bugs get silently swallowed. Always name the specific exception type(s) you expect."}', 6);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-6-2', 'course-python-level-2', 'chap-pyl2-06', 'lesson-pyl2-6-2', 2, 'Multiple except Blocks and else', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-6-2-dialogue', 'lesson-pyl2-6-2', 'dialogue', '{"shady": "In my file reader, three different things can go wrong \\u2014 the file might not exist, or I might not have permission to read it, or the content might be malformed. Do I need one big except for all? Like a chain? And what if nothing goes wrong?", "cody": "No \\u2014 you can have as many except blocks as you need. Each handles a different error type in the right way. Exactly. Python checks them in order, top to bottom, and runs the first one that matches. That''s what else is for. It runs only when try succeeded \\u2014 no exception at all."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-6-2-concept', 'lesson-pyl2-6-2', 'concept', '{"title": "Different errors need different responses. The `else` clause runs only when no error occurred.", "body": "The student handles multiple exception types and uses the `else` clause correctly."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-6-2-showcase', 'lesson-pyl2-6-2', 'showcase', '{"title": "Example", "language": "Python", "code": "filename = input(\\"File to open: \\")\\n\\ntry:\\n    with open(filename, \\"r\\") as f:\\n        content = f.read()\\n        number = int(content.strip())\\n\\nexcept FileNotFoundError:\\n    print(f\\"File ''{filename}'' does not exist.\\")\\nexcept PermissionError:\\n    print(f\\"You don''t have permission to read ''{filename}''.\\")\\nexcept ValueError:\\n    print(f\\"File exists but doesn''t contain a valid number.\\")", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-6-2-playground', 'lesson-pyl2-6-2', 'playground', '{"title": "Playground", "language": "Python", "code": "# File line counter with full error handling\\ndef count_lines(filename):\\n    try:\\n        with open(filename, \\"r\\") as f:\\n            lines = f.readlines()\\n    except FileNotFoundError:\\n        print(f\\"  Error: ''{filename}'' not found.\\")\\n        return None\\n    except PermissionError:\\n        print(f\\"  Error: No permission to read ''{filename}''.\\")\\n        return None\\n    except Exception as e:\\n        print(f\\"  Unexpected error: {e}\\")\\n        return None\\n    else:\\n        # Only runs if the file was opened and read successfully\\n        count = len([l for l in lines if l.strip()])\\n        print(f\\"  ''{filename}'' has {count} non-empty lines.\\")\\n        return count\\n\\n# Test with real and fake filenames:\\ncount_lines(\\"students.csv\\")   # should work if you ran ch.4 code\\ncount_lines(\\"ghost.txt\\")      # FileNotFoundError\\ncount_lines(\\"\\")               # FileNotFoundError or ValueError", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-6-2-challenge', 'lesson-pyl2-6-2', 'exercise', '{"title": "Mission", "instruction": "Write a function safe_load_number(filename) that:\\n1. Tries to open the file\\n2. If the file is missing \\u2192 print a specific message, return 0\\n3. If the file is found but empty \\u2192 print a specific message, return 0\\n4. If the file contains a valid integer \\u2192 return that integer\\n5. If the file contains invalid content \\u2192 print a specific message, return 0\\nUse separate except blocks for each case", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-6-2-quiz', 'lesson-pyl2-6-2', 'quiz', '{"question": "In a try/except/else block, when does the `else` clause execute?", "code": "", "options": [{"id": "A", "text": "When an exception IS raised"}, {"id": "B", "text": "Always \\u2014 after either try or except"}, {"id": "C", "text": "When the try block completes WITHOUT raising any exception"}, {"id": "D", "text": "Only when `else` is the last clause"}], "correct": "C", "explanation": "The `else` clause runs only if the `try` block executed completely without any exception. It''s a clean way to write \\"do this if everything worked\\" without putting it inside the try (where it could also trigger an exception)."}', 6);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-6-3', 'course-python-level-2', 'chap-pyl2-06', 'lesson-pyl2-6-3', 3, 'finally and raise', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-6-3-dialogue', 'lesson-pyl2-6-3', 'dialogue', '{"shady": "I need a database connection to stay open during a transaction. If anything goes wrong halfway, I still need to close the connection. How do I make sure the cleanup always happens? Finally what? And raise?", "cody": "finally. No \\u2014 the keyword ''finally''. Code in a finally block runs no matter what happens \\u2014 success, error, doesn''t matter. It''s the guarantee. raise lets you intentionally trigger an error. Useful when you want to enforce a rule \\u2014 like ''if the age is negative, that''s an error, even though Python didn''t detect it''."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-6-3-concept', 'lesson-pyl2-6-3', 'concept', '{"title": "`finally` always runs \\u2014 for cleanup. `raise` deliberately triggers an error \\u2014 for validation.", "body": "The student uses `finally` for cleanup and `raise` to enforce rules in functions."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-6-3-showcase', 'lesson-pyl2-6-3', 'showcase', '{"title": "Example", "language": "Python", "code": "def read_data(filename):\\n    f = None\\n    try:\\n        f = open(filename, \\"r\\")\\n        data = f.read()\\n        return data\\n    except FileNotFoundError:\\n        print(f\\"File ''{filename}'' not found.\\")\\n        return \\"\\"\\n    finally:\\n        # Runs ALWAYS \\u2014 whether try succeeded or except ran\\n        if f:\\n            f.close()\\n            print(\\"File closed.\\")    # always prints\\n\\n# Note: ''with'' handles this automatically \\u2014 finally is more useful\\n# for database connections, network sockets, and hardware resources", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-6-3-playground', 'lesson-pyl2-6-3', 'playground', '{"title": "Playground", "language": "Python", "code": "# Resource cleanup demonstration with finally\\nimport time\\n\\ndef simulate_task(task_name, should_fail=False):\\n    resource = None\\n    try:\\n        print(f\\"  [{task_name}] Starting...\\")\\n        resource = f\\"Connection-{task_name}\\"   # simulate opening a resource\\n        time.sleep(0.3)\\n\\n        if should_fail:\\n            raise RuntimeError(\\"Something went wrong mid-task!\\")\\n\\n        print(f\\"  [{task_name}] Completed successfully.\\")\\n        return True\\n\\n    except RuntimeError as e:\\n        print(f\\"  [{task_name}] Error: {e}\\")\\n        return False\\n\\n    finally:\\n        # Always runs \\u2014 clean up the resource\\n        if resource:\\n            print(f\\"  [{task_name}] Releasing {resource}\\")\\n\\nprint(\\"Task 1 (success):\\")\\nsimulate_task(\\"T1\\", should_fail=False)\\nprint()\\nprint(\\"Task 2 (failure):\\")\\nsimulate_task(\\"T2\\", should_fail=True)", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-6-3-challenge', 'lesson-pyl2-6-3', 'exercise', '{"title": "Mission", "instruction": "Write a function validate_email(email) that raises:\\n- TypeError if the input is not a string\\n- ValueError with message \\"Missing @ symbol\\" if there''s no @\\n- ValueError with message \\"Missing domain\\" if there''s nothing after the @\\n- ValueError with message \\"Missing extension\\" if the domain has no dot\\n\\nIf valid, return the email as lowercase.\\nTest it with: \\"Ahmed@school.eg\\", \\"notanemail\\", 123, \\"no-at-sign\\"", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-6-3-quiz', 'lesson-pyl2-6-3', 'quiz', '{"question": "When does the `finally` block NOT execute?", "code": "", "options": [{"id": "A", "text": "When an exception is raised in `try`"}, {"id": "B", "text": "When the `try` block returns early"}, {"id": "C", "text": "`finally` always executes \\u2014 there are virtually no normal cases where it doesn''t"}, {"id": "D", "text": "When `except` handles the error"}], "correct": "C", "explanation": "`finally` is designed to **always** run \\u2014 even if `try` returns, even if `except` returns, even if another exception is raised. The only extreme exceptions are a power cut or `os._exit()` \\u2014 not normal programming scenarios."}', 6);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-6-4', 'course-python-level-2', 'chap-pyl2-06', 'lesson-pyl2-6-4', 4, 'Mini Project — Bulletproof Input Handler', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-6-4-dialogue', 'lesson-pyl2-6-4', 'dialogue', '{"shady": "I keep rewriting the same ''ask the user for a number, handle the error, ask again'' loop in every program I build. So I write it once and use it everywhere?", "cody": "That''s a sign it belongs in a utility module \\u2014 one place where it''s written well, tested, and imported wherever you need it. That''s one of the most professional things you can do as a programmer. Don''t repeat yourself \\u2014 extract the pattern."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-6-4-concept', 'lesson-pyl2-6-4', 'concept', '{"title": "Build a reusable module of safe input functions that never crash, no matter what the user types.", "body": "The student writes a complete input validation utility using all error handling skills."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-6-4-showcase', 'lesson-pyl2-6-4', 'showcase', '{"title": "Example", "language": "Python", "code": "# \\u2500\\u2500 safe_input.py \\u2014 reusable input utility \\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\n\\ndef get_int(prompt, min_val=None, max_val=None):\\n    \\"\\"\\"Get a valid integer from the user, optionally within a range.\\"\\"\\"\\n    while True:\\n        try:\\n            value = int(input(prompt))\\n            if min_val is not None and value < min_val:\\n                raise ValueError(f\\"Must be at least {min_val}\\")\\n            if max_val is not None and value > max_val:\\n                raise ValueError(f\\"Must be at most {max_val}\\")\\n            return value\\n        except ValueError as e:\\n            print(f\\"  \\u2718 Invalid: {e}. Please try again.\\")\\n\\ndef get_float(prompt, min_val=None, max_val=None):\\n    \\"\\"\\"Get a valid float from the user, optionally within a range.\\"\\"\\"\\n    while True:\\n        try:\\n            value = float(input(prompt))\\n            if min_val is not None and value < min_val:\\n                raise ValueError(f\\"Must be at least {min_val}\\")\\n            if max_val is not None and value > max_val:\\n                raise ValueError(f\\"Must be at most {max_val}\\")\\n            return value\\n        except ValueError as e:\\n            print(f\\"  \\u2718 Invalid: {e}. Please try again.\\")\\n\\ndef get_choice(prompt, options):\\n    \\"\\"\\"Get a choice from a list of allowed options.\\"\\"\\"\\n    options_str = \\"/\\".join(options)\\n    while True:\\n        answer = input(f\\"{prompt} ({options_str}): \\").strip().lower()\\n        if answer in [o.lower() for o in options]:\\n            return answer\\n        print(f\\"  \\u2718 Please choose from: {options_str}\\")\\n\\ndef get_yes_no(prompt):\\n    \\"\\"\\"Get a yes/no answer \\u2014 returns True for yes, False for no.\\"\\"\\"\\n    choice = get_choice(prompt, [\\"yes\\", \\"no\\"])\\n    return choice == \\"yes\\"\\n\\ndef get_non_empty_string(prompt, max_length=None):\\n    \\"\\"\\"Get a non-empty string from the user.\\"\\"\\"\\n    while True:\\n        value = input(prompt).strip()\\n        if not value:\\n            print(\\"  \\u2718 This field cannot be empty.\\")\\n            continue\\n        if max_length and len(value) > max_length:\\n            print(f\\"  \\u2718 Maximum {max_length} characters.\\")\\n            continue\\n        return value\\n\\n\\n# \\u2500\\u2500 Demo: using the utility \\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\nif __name__ == \\"__main__\\":\\n    print(\\"=== Registration Form ===\\\\n\\")\\n    name  = get_non_empty_string(\\"Your name: \\", max_length=30)\\n    age   = get_int(\\"Your age: \\", min_val=10, max_val=100)\\n    score = get_float(\\"Your score (0-100): \\", min_val=0.0, max_val=100.0)\\n    wants_certificate = get_yes_no(\\"Do you want a certificate?\\")\\n\\n    print(f\\"\\\\n--- Summary ---\\")\\n    print(f\\"Name:        {name}\\")\\n    print(f\\"Age:         {age}\\")\\n    print(f\\"Score:       {score:.1f}\\")\\n    print(f\\"Certificate: {''Yes'' if wants_certificate else ''No''}\\")", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-6-4-playground', 'lesson-pyl2-6-4', 'playground', '{"title": "Playground", "language": "Python", "code": "# Quick version to test the concept\\ndef get_int_safe(prompt, low=None, high=None):\\n    while True:\\n        try:\\n            val = int(input(prompt))\\n            if low is not None and val < low:\\n                print(f\\"  Must be >= {low}\\")\\n                continue\\n            if high is not None and val > high:\\n                print(f\\"  Must be <= {high}\\")\\n                continue\\n            return val\\n        except ValueError:\\n            print(\\"  Please enter a whole number.\\")\\n\\n# Test it:\\nscore  = get_int_safe(\\"Score (0-100): \\", low=0, high=100)\\ngrade  = get_int_safe(\\"Grade (1-12):  \\", low=1, high=12)\\nprint(f\\"Recorded: Grade {grade}, Score {score}\\")", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-6-4-challenge', 'lesson-pyl2-6-4', 'exercise', '{"title": "Mission", "instruction": "Add a get_date(prompt) function to the utility that:\\n1. Asks the user for a date in format \\"DD/MM/YYYY\\"\\n2. Tries to parse it with datetime.strptime\\n3. If parsing fails \\u2192 print \\"Invalid date format, use DD/MM/YYYY\\" and ask again\\n4. If the date is in the past \\u2192 print \\"That date has passed\\" and ask again\\n5. Returns the datetime.date object when valid", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-6-4-quiz', 'lesson-pyl2-6-4', 'quiz', '{"question": "Why is the `while True:` loop essential inside the safe input functions?", "code": "", "options": [{"id": "A", "text": "To run the function multiple times automatically"}, {"id": "B", "text": "To keep asking until the user provides valid input \\u2014 the loop exits only with `return`"}, {"id": "C", "text": "To prevent the function from returning `None`"}, {"id": "D", "text": "It''s not essential \\u2014 `if` statements would work the same way"}], "correct": "B", "explanation": "The `while True` loop keeps retrying after each failed attempt. When the input is valid, `return value` exits the loop and the function. Without the loop, a single bad input would cause the function to end with no return value."}', 6);

INSERT INTO exams (id, course_id, chapter_id, title, pass_threshold, exam_type)
VALUES ('exam-pyl2-ch06', 'course-python-level-2', 'chap-pyl2-06', 'Chapter 6 Exam', 60, 'chapter');
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch06-01', 'exam-pyl2-ch06', 'What does a bare `except:` (no type) catch?', 'MCQ', '[{"id": "A", "text": "Only ValueError  B) Only RuntimeError  C) All exceptions, including system ones"}]', 'A', '', 1);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch06-02', 'exam-pyl2-ch06', 'The `else` clause in try/except runs when:', 'MCQ', '[{"id": "A", "text": "An exception is caught  B) No exception was raised"}]', 'A', '', 2);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch06-03', 'exam-pyl2-ch06', '`finally` runs:', 'MCQ', '[{"id": "A", "text": "Only when no exception occurs  B) Only when an exception occurs  C) Always"}]', 'A', '', 3);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch06-04', 'exam-pyl2-ch06', 'You want to stop your function if the input is negative and tell the caller it''s invalid. You should:', 'MCQ', '[{"id": "A", "text": "`return False`  B) `print("}]', 'A', '', 4);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch06-05', 'exam-pyl2-ch06', 'Write a function `safe_open_and_count(filename)` that tries to open a file, counts its words, and returns the count. Handle `FileNotFoundError` (return 0), `PermissionError` (return -1), and use `finally` to print "Attempted to read [filename]" regardless of outcome.', 'Coding', '[]', 'A', '', 5);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch06-06', 'exam-pyl2-ch06', 'Write a `get_positive_float(prompt)` function that keeps asking until the user enters a positive number. Handle `ValueError`, reject 0 and negative numbers with a descriptive message, and return the valid value.

---

---', 'Coding', '[]', 'A', '', 6);

INSERT INTO chapters (id, course_id, slug, chapter_number, title, description)
VALUES ('chap-pyl2-07', 'course-python-level-2', 'list-comprehensions', 7, 'Writing Less, Doing More — List Comprehensions', 'List comprehensions are a powerful, Pythonic way to build lists in one line. Concise, readable, fast.');

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-7-1', 'course-python-level-2', 'chap-pyl2-07', 'lesson-pyl2-7-1', 1, 'Basic List Comprehensions', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-7-1-dialogue', 'lesson-pyl2-7-1', 'dialogue', '{"shady": "I write this pattern constantly: result = [] for item in some_list:     result.append(transform(item)) It''s four lines every time. Is there a shorter way? How does it look? That IS more readable.", "cody": "List comprehension. One line. [transform(item) for item in some_list] Same result, one line, reads almost like English: ''transform each item for each item in this list''. When it''s simple. As it gets complex, the loop becomes clearer. Comprehensions are a tool \\u2014 not a rule to apply everywhere."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-7-1-concept', 'lesson-pyl2-7-1', 'concept', '{"title": "A list comprehension creates a new list by applying an expression to each item in an iterable \\u2014 in a single line.", "body": "The student rewrites for-loop list builders as comprehensions and understands the structure."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-7-1-showcase', 'lesson-pyl2-7-1', 'showcase', '{"title": "Example", "language": "Python", "code": "numbers = [1, 2, 3, 4, 5]\\n\\n# \\u2500\\u2500 For loop way \\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\nsquares_loop = []\\nfor n in numbers:\\n    squares_loop.append(n ** 2)\\n\\n# \\u2500\\u2500 Comprehension way \\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\nsquares_comp = [n ** 2 for n in numbers]\\n\\nprint(squares_loop)    # [1, 4, 9, 16, 25]\\nprint(squares_comp)    # [1, 4, 9, 16, 25]  \\u2014 identical result", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-7-1-playground', 'lesson-pyl2-7-1', 'playground', '{"title": "Playground", "language": "Python", "code": "students = [\\"ahmed\\", \\"sara\\", \\"omar\\", \\"nour\\", \\"ali\\"]\\nscores = [85, 92, 68, 95, 74]\\n\\n# 1. Capitalize all names\\nproper_names = [name.capitalize() for name in students]\\nprint(\\"Names:\\", proper_names)\\n\\n# 2. Add 5 bonus points to each score\\nbonus_scores = [s + 5 for s in scores]\\nprint(\\"With bonus:\\", bonus_scores)\\n\\n# 3. Convert scores to percentages (out of 100, already %)\\nlabels = [f\\"{s}%\\" for s in scores]\\nprint(\\"Labels:\\", labels)\\n\\n# TODO: Create a list of (name, score) tuples using zip()\\n# Hint: [(n, s) for n, s in zip(students, scores)]\\n# TODO: Create a list of all score squared\\n# TODO: Create a list of names in ALL CAPS", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-7-1-challenge', 'lesson-pyl2-7-1', 'exercise', '{"title": "Mission", "instruction": "1. Generate a list of all perfect squares from 1 to 100 (1, 4, 9, ... 100) \\u2014 one line\\n2. Given a list of temperatures in Celsius, create a list of the same temperatures in Fahrenheit\\n3. Given a list of filenames, create a list of only the filenames (remove the path)\\n   Hint: [\\"folder/file.txt\\".split(\\"/\\")[-1] for ...]\\n4. Create a list of all even numbers from 1 to 50 that are also divisible by 3", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-7-1-quiz', 'lesson-pyl2-7-1', 'quiz', '{"question": "What does `[x * 2 for x in range(5)]` produce?", "code": "", "options": [{"id": "A", "text": "`[0, 2, 4, 6, 8, 10]`"}, {"id": "B", "text": "`[2, 4, 6, 8, 10]`"}, {"id": "C", "text": "`[0, 2, 4, 6, 8]`"}, {"id": "D", "text": "`[1, 2, 3, 4, 5]`"}], "correct": "C", "explanation": "`range(5)` gives 0, 1, 2, 3, 4. Multiplied by 2: 0, 2, 4, 6, 8. That''s 5 elements, starting from 0."}', 6);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-7-2', 'course-python-level-2', 'chap-pyl2-07', 'lesson-pyl2-7-2', 2, 'Filtered List Comprehensions', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-7-2-dialogue', 'lesson-pyl2-7-2', 'dialogue', '{"shady": "I have a list of all 30 students'' scores. I want only the ones above 60. Do I need a for loop with an if inside? At the end?", "cody": "Or one line. Add an if condition at the end of the comprehension. Yes \\u2014 [expression for item in list if condition]. The condition acts as a filter \\u2014 only items that pass get included."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-7-2-concept', 'lesson-pyl2-7-2', 'concept', '{"title": "Adding an `if` condition to a comprehension filters which items make it into the result list.", "body": "The student writes comprehensions that filter items by condition."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-7-2-showcase', 'lesson-pyl2-7-2', 'showcase', '{"title": "Example", "language": "Python", "code": "scores = [45, 82, 58, 90, 37, 75, 88, 62]\\n\\n# \\u2500\\u2500 For loop with filter \\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\npassing = []\\nfor s in scores:\\n    if s >= 60:\\n        passing.append(s)\\n\\n# \\u2500\\u2500 Comprehension with filter \\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\npassing = [s for s in scores if s >= 60]\\nprint(passing)    # [82, 90, 75, 88, 62]", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-7-2-playground', 'lesson-pyl2-7-2', 'playground', '{"title": "Playground", "language": "Python", "code": "students = [\\n    {\\"name\\": \\"Ahmed\\", \\"score\\": 95, \\"grade\\": 10},\\n    {\\"name\\": \\"Sara\\",  \\"score\\": 42, \\"grade\\": 11},\\n    {\\"name\\": \\"Omar\\",  \\"score\\": 78, \\"grade\\": 10},\\n    {\\"name\\": \\"Nour\\",  \\"score\\": 88, \\"grade\\": 11},\\n    {\\"name\\": \\"Ali\\",   \\"score\\": 35, \\"grade\\": 10},\\n]\\n\\n# Extract only passing students (score >= 50)\\npassing = [s for s in students if s[\\"score\\"] >= 50]\\nprint(\\"Passing:\\")\\nfor s in passing:\\n    print(f\\"  {s[''name'']}: {s[''score'']}\\")\\n\\n# Names of grade 10 students only\\ngrade_10 = [s[\\"name\\"] for s in students if s[\\"grade\\"] == 10]\\nprint(f\\"\\\\nGrade 10: {grade_10}\\")\\n\\n# TODO: Get names of students who failed (score < 50)\\n# TODO: Get scores of grade 11 students\\n# TODO: Create a list of \\"Pass\\"/\\"Fail\\" labels for every student (in order)", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-7-2-challenge', 'lesson-pyl2-7-2', 'exercise', '{"title": "Mission", "instruction": "Given: numbers = [14, 27, -3, 0, 55, -8, 42, -1, 100, 6]\\n1. Create a list of only positive numbers\\n2. Create a list of numbers divisible by 7\\n3. Create a list of numbers that are both positive AND divisible by 7\\n4. Create a list where each number is replaced by its absolute value\\n5. Create a list of (\\"positive\\"/\\"negative\\"/\\"zero\\") labels for each number", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-7-2-quiz', 'lesson-pyl2-7-2', 'quiz', '{"question": "What does `[n for n in range(10) if n % 2 != 0]` produce?", "code": "", "options": [{"id": "A", "text": "`[0, 2, 4, 6, 8]`"}, {"id": "B", "text": "`[1, 3, 5, 7, 9]`"}, {"id": "C", "text": "`[2, 4, 6, 8, 10]`"}, {"id": "D", "text": "`[]`"}], "correct": "B", "explanation": "`n % 2 != 0` is True when n is odd. `range(10)` gives 0\\u20139. The odd numbers in that range are 1, 3, 5, 7, 9."}', 6);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-7-3', 'course-python-level-2', 'chap-pyl2-07', 'lesson-pyl2-7-3', 3, 'Dictionary and Set Comprehensions', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-7-3-dialogue', 'lesson-pyl2-7-3', 'dialogue', '{"shady": "Can I do the same thing with dictionaries? I have a list of names and a list of scores and I want to zip them into a dict in one line. And sets?", "cody": "Dictionary comprehension. Same idea, different brackets. Curly braces and a key: value expression. Curly braces with just a value \\u2014 no colon. The set handles the uniqueness automatically."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-7-3-concept', 'lesson-pyl2-7-3', 'concept', '{"title": "The same comprehension syntax works for creating dictionaries (`{key: val for ...}`) and sets (`{expr for ...}`).", "body": "The student builds dictionaries and sets using comprehension syntax."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-7-3-showcase', 'lesson-pyl2-7-3', 'showcase', '{"title": "Example", "language": "Python", "code": "# {key_expression: value_expression for item in iterable}\\n\\nnames  = [\\"Ahmed\\", \\"Sara\\", \\"Omar\\"]\\nscores = [95, 88, 72]\\n\\n# Zip them into a dictionary\\ngrade_book = {name: score for name, score in zip(names, scores)}\\nprint(grade_book)\\n# {''Ahmed'': 95, ''Sara'': 88, ''Omar'': 72}", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-7-3-playground', 'lesson-pyl2-7-3', 'playground', '{"title": "Playground", "language": "Python", "code": "students = [\\"Ahmed\\", \\"Sara\\", \\"Omar\\", \\"Nour\\", \\"Ali\\"]\\nscores   = [95, 42, 78, 88, 35]\\n\\n# Build grade_book dictionary\\ngrade_book = {name: score for name, score in zip(students, scores)}\\nprint(\\"Grade book:\\", grade_book)\\n\\n# Build a letter_grade dict (A/B/C/D/F)\\ndef letter(score):\\n    if score >= 90: return \\"A\\"\\n    if score >= 80: return \\"B\\"\\n    if score >= 70: return \\"C\\"\\n    if score >= 60: return \\"D\\"\\n    return \\"F\\"\\n\\nletter_grades = {name: letter(score) for name, score in grade_book.items()}\\nprint(\\"Letter grades:\\", letter_grades)\\n\\n# TODO: Create a set of all unique letter grades\\n# TODO: Create a dict of only \\"A\\" and \\"B\\" students\\n# TODO: Create a dict of {name: score + 10} for all failing students (score < 50)", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-7-3-challenge', 'lesson-pyl2-7-3', 'exercise', '{"title": "Mission", "instruction": "1. Given a list of words, create a dict mapping each word to its length\\n2. Given the dict from above, create a new dict keeping only words longer than 4 characters\\n3. Create a set of all unique vowels found in a long string\\n4. Given a list of email addresses, create a dict mapping each email to its domain\\n   (the part after @)\\n   e.g. \\"ahmed@school.eg\\" \\u2192 domain \\"school.eg\\"", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-7-3-quiz', 'lesson-pyl2-7-3', 'quiz', '{"question": "What does `{n: n**2 for n in range(4) if n % 2 == 0}` produce?", "code": "", "options": [{"id": "A", "text": "`{0, 4}`"}, {"id": "B", "text": "`{0: 0, 4: 16}`"}, {"id": "C", "text": "`{0: 0, 2: 4}`"}, {"id": "D", "text": "`{1: 1, 3: 9}`"}], "correct": "C", "explanation": "`range(4)` is 0, 1, 2, 3. Filter `n % 2 == 0` keeps 0 and 2. Then `n: n**2` maps 0\\u21920, 2\\u21924. Result: `{0: 0, 2: 4}`."}', 6);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-7-4', 'course-python-level-2', 'chap-pyl2-07', 'lesson-pyl2-7-4', 4, 'Nested Comprehensions and When NOT to Use Them', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-7-4-dialogue', 'lesson-pyl2-7-4', 'dialogue', '{"shady": "Can I put a comprehension inside a comprehension? Show me.", "cody": "Yes. Useful for 2D data \\u2014 like a grid or a matrix. Here''s the key rule first: if someone else can''t read it in 5 seconds, use a loop. Comprehensions are for clarity, not cleverness. The moment they become hard to read, they''ve failed their purpose."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-7-4-concept', 'lesson-pyl2-7-4', 'concept', '{"title": "Comprehensions can be nested for 2D data, but readability has clear limits \\u2014 know when to stop.", "body": "The student writes a simple nested comprehension for a matrix and articulates when a regular loop is the better choice."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-7-4-showcase', 'lesson-pyl2-7-4', 'showcase', '{"title": "Example", "language": "Python", "code": "# Create a 3\\u00d73 matrix (list of lists)\\nmatrix = [[row * 3 + col for col in range(3)] for row in range(3)]\\nprint(matrix)\\n# [[0, 1, 2], [3, 4, 5], [6, 7, 8]]", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-7-4-playground', 'lesson-pyl2-7-4', 'playground', '{"title": "Playground", "language": "Python", "code": "# Multiplication table as a 2D list\\nsize = 5\\n\\ntable = [[row * col for col in range(1, size + 1)] for row in range(1, size + 1)]\\n\\n# Print it formatted\\nprint(f\\"{'''':>4}\\", end=\\"\\")\\nfor col in range(1, size + 1):\\n    print(f\\"{col:>4}\\", end=\\"\\")\\nprint()\\nprint(\\"\\u2500\\" * (4 * (size + 1)))\\n\\nfor i, row in enumerate(table):\\n    print(f\\"{i+1:>4}\\", end=\\"\\")\\n    for val in row:\\n        print(f\\"{val:>4}\\", end=\\"\\")\\n    print()", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-7-4-challenge', 'lesson-pyl2-7-4', 'exercise', '{"title": "Mission", "instruction": "1. Use a nested comprehension to create a 4\\u00d74 grid where each cell is (row, col)\\n   e.g. [[(0,0), (0,1), ...], [(1,0), ...], ...]\\n2. Flatten a given nested list: [[1,2],[3,4],[5]] \\u2192 [1,2,3,4,5] using comprehension\\n3. Given the flat list [1,2,3,4,5,6,7,8,9], create a 3\\u00d73 nested list using a comprehension\\n   Hint: [[flat[row*3 + col] for col in range(3)] for row in range(3)]", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-7-4-quiz', 'lesson-pyl2-7-4', 'quiz', '{"question": "You have `[[1,2],[3,4],[5,6]]`. What does `[x for row in data for x in row]` produce?", "code": "", "options": [{"id": "A", "text": "`[[1,2],[3,4],[5,6]]` \\u2014 unchanged"}, {"id": "B", "text": "`[1,2,3,4,5,6]`"}, {"id": "C", "text": "`[[1,3,5],[2,4,6]]`"}, {"id": "D", "text": "`SyntaxError`"}], "correct": "B", "explanation": "The outer loop iterates through rows (`[1,2]`, `[3,4]`, `[5,6]`). The inner loop iterates through each `x` in each `row`. All `x` values collected in order: 1, 2, 3, 4, 5, 6."}', 6);

INSERT INTO exams (id, course_id, chapter_id, title, pass_threshold, exam_type)
VALUES ('exam-pyl2-ch07', 'course-python-level-2', 'chap-pyl2-07', 'Chapter 7 Exam', 60, 'chapter');
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch07-01', 'exam-pyl2-ch07', '`[x**2 for x in range(1, 5)]` produces:', 'MCQ', '[{"id": "A", "text": "`[1, 4, 9, 16, 25]`  B) `[1, 4, 9, 16]`"}]', 'A', '', 1);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch07-02', 'exam-pyl2-ch07', '`[x for x in [10, 25, 7, 42, 3] if x > 10]` produces:', 'MCQ', '[{"id": "A", "text": "`[25, 42]`"}]', 'A', '', 2);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch07-03', 'exam-pyl2-ch07', 'What does `{k: v*2 for k, v in {"a":1,"b":2}.items()}` produce?', 'MCQ', '[{"id": "A", "text": "`{"}]', 'A', '', 3);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch07-04', 'exam-pyl2-ch07', '`{"apple","banana","Apple","BANANA"}` — how many items in this set?', 'MCQ', '[{"id": "A", "text": "4  B) 2  C) 3"}]', 'A', '', 4);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch07-05', 'exam-pyl2-ch07', 'Write one line of code that, given a list of strings `words`, produces a dictionary where each key is a word (lowercased) and each value is its length — but only for words longer than 3 characters.

---

---', 'Coding', '[]', 'A', '', 5);

INSERT INTO chapters (id, course_id, slug, chapter_number, title, description)
VALUES ('chap-pyl2-08', 'course-python-level-2', 'functions-deeper', 8, 'Functions — Going Deeper', 'Students know basic functions. Now: variable scope, default arguments, flexible argument lists, and lambda.');

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-8-1', 'course-python-level-2', 'chap-pyl2-08', 'lesson-pyl2-8-1', 1, 'Scope — Where Variables Live', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-8-1-dialogue', 'lesson-pyl2-8-1', 'dialogue', '{"shady": "I set a variable called score inside my function. Then I tried to print it outside and got NameError. But I defined it! Where did it go? Like what happens in the kitchen stays in the kitchen? So inside can see outside, but outside can''t see inside?", "cody": "It went out of scope. Variables born inside a function live only inside that function. When the function ends, they disappear. Perfect analogy. The kitchen (function) has its own variables. The dining room (outside) can''t see them. But the dining room''s variables \\u2014 those ARE visible inside the kitchen. Exactly. That''s scope."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-8-1-concept', 'lesson-pyl2-8-1', 'concept', '{"title": "A variable created inside a function exists only inside it (local scope). Variables outside are global. Mixing them carelessly causes subtle bugs.", "body": "The student identifies local vs global scope, explains why scope matters, and avoids the global keyword."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-8-1-showcase', 'lesson-pyl2-8-1', 'showcase', '{"title": "Example", "language": "Python", "code": "def calculate():\\n    result = 42     # local variable \\u2014 born here\\n    print(result)   # \\u2705 works inside\\n\\ncalculate()\\nprint(result)       # \\u274c NameError: name ''result'' is not defined\\n                    # result only existed inside calculate()", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-8-1-playground', 'lesson-pyl2-8-1', 'playground', '{"title": "Playground", "language": "Python", "code": "# Explore scope rules\\ntotal = 0   # global\\n\\ndef add_to_total(amount):\\n    # Can we read ''total'' here? YES \\u2014 it''s global\\n    print(f\\"  Current total before: {total}\\")\\n    # Can we change ''total'' directly? NO \\u2014 UnboundLocalError\\n\\n    # \\u2705 Return the new value instead:\\n    return total + amount\\n\\ntotal = add_to_total(50)\\nprint(f\\"After first add: {total}\\")\\n\\ntotal = add_to_total(25)\\nprint(f\\"After second add: {total}\\")\\n\\n# Safe: add_to_total never modifies global directly\\n# The caller (main code) updates total with the returned value", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-8-1-challenge', 'lesson-pyl2-8-1', 'exercise', '{"title": "Mission", "instruction": "1. Write a function power_of(base, exponent) that returns base^exponent\\n2. Create a variable ''base = 3'' in the global scope\\n3. Inside the function, what happens if you use ''base'' without passing it as a parameter?\\n   Try it \\u2014 explain what you observe\\n4. Fix it properly by always passing base as a parameter\\n5. Write a short comment explaining why functions with parameters are better than\\n   functions that rely on global variables", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-8-1-quiz', 'lesson-pyl2-8-1', 'quiz', '{"question": "A variable defined inside a function can be accessed:", "code": "", "options": [{"id": "A", "text": "Anywhere in the program"}, {"id": "B", "text": "Only inside that function \\u2014 it disappears when the function returns"}, {"id": "C", "text": "In any function defined after this one"}, {"id": "D", "text": "Only if declared with the `global` keyword"}], "correct": "B", "explanation": "Variables defined inside a function are local \\u2014 they exist only during that function''s execution. When the function returns, all its local variables are discarded. This is intentional: it keeps functions self-contained and prevents them from interfering with each other."}', 6);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-8-2', 'course-python-level-2', 'chap-pyl2-08', 'lesson-pyl2-8-2', 2, 'Default Parameters and Keyword Arguments', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-8-2-dialogue', 'lesson-pyl2-8-2', 'dialogue', '{"shady": "I have a function that creates a student report \\u2014 it always uses the same school name and year, but occasionally I need to change them. Do I have to pass them every single time? And keyword arguments?", "cody": "No. Give them default values. If the caller doesn''t provide them \\u2014 Python uses the default. If they do \\u2014 Python uses what they passed. Those let you pass arguments by name, not by position. Useful when a function has many parameters and you want to be explicit about which is which."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-8-2-concept', 'lesson-pyl2-8-2', 'concept', '{"title": "Parameters can have default values. Arguments can be passed by name rather than position.", "body": "The student writes functions with default parameters and calls them using keyword arguments."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-8-2-showcase', 'lesson-pyl2-8-2', 'showcase', '{"title": "Example", "language": "Python", "code": "def greet(name, greeting=\\"Hello\\", punctuation=\\"!\\"):\\n    return f\\"{greeting}, {name}{punctuation}\\"\\n\\nprint(greet(\\"Ahmed\\"))                      # Hello, Ahmed!\\nprint(greet(\\"Sara\\", \\"Hi\\"))                 # Hi, Sara!\\nprint(greet(\\"Omar\\", \\"Welcome\\", \\".\\"))       # Welcome, Omar.", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-8-2-playground', 'lesson-pyl2-8-2', 'playground', '{"title": "Playground", "language": "Python", "code": "def generate_student_card(name, grade, score, school=\\"Salam Prep\\",\\n                          show_grade=True, show_score=True):\\n    lines = [f\\"{''=''*30}\\", f\\"  {school}\\", f\\"{''\\u2500''*30}\\", f\\"  Name:  {name}\\"]\\n    if show_grade:\\n        lines.append(f\\"  Grade: {grade}\\")\\n    if show_score:\\n        status = \\"Pass\\" if score >= 50 else \\"Fail\\"\\n        lines.append(f\\"  Score: {score}/100  [{status}]\\")\\n    lines.append(f\\"{''=''*30}\\")\\n    return \\"\\\\n\\".join(lines)\\n\\n# Default card\\nprint(generate_student_card(\\"Ahmed\\", 10, 85))\\nprint()\\n\\n# Custom card \\u2014 different school, no score shown\\nprint(generate_student_card(\\"Sara\\", 11, 92, school=\\"Cairo STEM\\", show_score=False))\\nprint()\\n\\n# TODO: Call it with only name, grade, score \\u2014 observe the defaults at work\\n# TODO: Call it with grade=10, score=55, name=\\"Omar\\" using keyword arguments (wrong order)", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-8-2-challenge', 'lesson-pyl2-8-2', 'exercise', '{"title": "Mission", "instruction": "Write a function format_currency(amount, currency=\\"EGP\\", decimal_places=2, show_symbol=True)\\nthat formats a number as a currency string.\\nExamples:\\n  format_currency(1500)           \\u2192 \\"1500.00 EGP\\"\\n  format_currency(1500, \\"USD\\")    \\u2192 \\"1500.00 USD\\"\\n  format_currency(1500, decimal_places=0)  \\u2192 \\"1500 EGP\\"\\n  format_currency(1500, show_symbol=False) \\u2192 \\"1500.00\\"", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-8-2-quiz', 'lesson-pyl2-8-2', 'quiz', '{"question": "`def greet(name, msg=\\"Hello\\"):` is called as `greet(msg=\\"Hi\\", name=\\"Shady\\")`. What prints?", "code": "", "options": [{"id": "A", "text": "SyntaxError \\u2014 wrong order"}, {"id": "B", "text": "\\"Hello, Shady\\" \\u2014 msg is ignored"}, {"id": "C", "text": "\\"Hi, Shady\\""}, {"id": "D", "text": "\\"Hi, msg\\""}], "correct": "C", "explanation": "Keyword arguments can be passed in any order \\u2014 Python matches them by name. `msg=\\"Hi\\"` overrides the default, `name=\\"Shady\\"` provides the required argument."}', 6);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-8-3', 'course-python-level-2', 'chap-pyl2-08', 'lesson-pyl2-8-3', 3, '*args and **kwargs', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-8-3-dialogue', 'lesson-pyl2-8-3', 'dialogue', '{"shady": "I want to write a sum function that works whether I pass it 2 numbers or 10. Do I need to write a different function for each case? Like Python''s built-in sum()? And **kwargs?", "cody": "No. Use *args. It collects however many arguments you pass into a tuple. Exactly \\u2014 except sum() takes a list. With *args, you don''t even need the brackets. You just pass the numbers directly. For keyword arguments. Collects all name=value pairs into a dictionary. Great when you don''t know in advance which settings someone might pass."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-8-3-concept', 'lesson-pyl2-8-3', 'concept', '{"title": "`*args` collects any number of positional arguments as a tuple. `**kwargs` collects any number of keyword arguments as a dictionary.", "body": "The student writes functions that accept a flexible number of arguments using `*args` and `**kwargs`."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-8-3-showcase', 'lesson-pyl2-8-3', 'showcase', '{"title": "Example", "language": "Python", "code": "def my_sum(*args):\\n    # args is a tuple of all positional arguments passed\\n    print(f\\"args = {args}\\")\\n    return sum(args)\\n\\nprint(my_sum(1, 2))           # args = (1, 2) \\u2192 3\\nprint(my_sum(1, 2, 3, 4, 5))  # args = (1, 2, 3, 4, 5) \\u2192 15\\nprint(my_sum())               # args = () \\u2192 0", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-8-3-playground', 'lesson-pyl2-8-3', 'playground', '{"title": "Playground", "language": "Python", "code": "# Flexible report generator\\ndef generate_report(title, *sections, separator=\\"\\u2500\\"*30, **metadata):\\n    print(\\"=\\" * 30)\\n    print(f\\"  {title}\\")\\n    print(\\"=\\" * 30)\\n\\n    if metadata:\\n        for key, val in metadata.items():\\n            print(f\\"  {key.replace(''_'', '' '').title()}: {val}\\")\\n        print(separator)\\n\\n    for i, section in enumerate(sections, 1):\\n        print(f\\"  {i}. {section}\\")\\n\\n    print(\\"=\\" * 30)\\n\\ngenerate_report(\\n    \\"Student Report\\",\\n    \\"Completed Chapter 1\\",\\n    \\"Completed Chapter 2\\",\\n    \\"Passed Chapter 2 Exam\\",\\n    student=\\"Ahmed\\",\\n    date=\\"2024-09-15\\",\\n    overall_grade=\\"B+\\"\\n)", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-8-3-challenge', 'lesson-pyl2-8-3', 'exercise', '{"title": "Mission", "instruction": "1. Write my_max(*args) that returns the largest value from any number of arguments\\n   (don''t use the built-in max() inside it \\u2014 use a loop)\\n2. Write describe(**attributes) that prints each attribute on a line: \\"colour: blue\\"\\n3. Write format_table(*rows, headers=None) that prints a simple text table\\n   Each row is a tuple. If headers is provided, print them first.", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-8-3-quiz', 'lesson-pyl2-8-3', 'quiz', '{"question": "In `def func(*args, **kwargs)`, if you call `func(1, 2, name=\\"Shady\\")`, what is `kwargs`?", "code": "", "options": [{"id": "A", "text": "`(1, 2, \\"Shady\\")`"}, {"id": "B", "text": "`{\\"name\\": \\"Shady\\"}`"}, {"id": "C", "text": "`{\\"1\\": None, \\"2\\": None, \\"name\\": \\"Shady\\"}`"}, {"id": "D", "text": "`[1, 2]`"}], "correct": "B", "explanation": "`args` collects positional arguments: `(1, 2)`. `kwargs` collects keyword arguments: `{\\"name\\": \\"Shady\\"}`. They''re separate \\u2014 positional in the tuple, keyword in the dict."}', 6);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-8-4', 'course-python-level-2', 'chap-pyl2-08', 'lesson-pyl2-8-4', 4, 'Lambda Functions', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-8-4-dialogue', 'lesson-pyl2-8-4', 'dialogue', '{"shady": "I want to sort my list of student dictionaries by their score. I know sorted() takes a key argument \\u2014 but what do I pass? Lambda sounds complicated. That''s... actually simple.", "cody": "A function that takes one element and returns the sort key. You could write a full def \\u2014 or use a lambda for a quick one-liner. It''s the simplest possible function. No name, no def, one expression, one line. lambda x: x[''score''] means ''a function that takes x and returns x[\\\\ That''s the whole point."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-8-4-concept', 'lesson-pyl2-8-4', 'concept', '{"title": "A lambda is a compact, anonymous (nameless) one-line function \\u2014 useful as a throwaway function for sorting, filtering, and mapping.", "body": "The student writes lambda functions and uses them as the `key` argument in `sorted()`."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-8-4-showcase', 'lesson-pyl2-8-4', 'showcase', '{"title": "Example", "language": "Python", "code": "# Regular function:\\ndef square(x):\\n    return x ** 2\\n\\n# Lambda equivalent:\\nsquare = lambda x: x ** 2\\n\\nprint(square(5))    # 25", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-8-4-playground', 'lesson-pyl2-8-4', 'playground', '{"title": "Playground", "language": "Python", "code": "products = [\\n    {\\"name\\": \\"Notebook\\",   \\"price\\": 15.00, \\"stock\\": 100},\\n    {\\"name\\": \\"Pen\\",        \\"price\\":  3.50, \\"stock\\":  50},\\n    {\\"name\\": \\"Ruler\\",      \\"price\\":  8.00, \\"stock\\":  75},\\n    {\\"name\\": \\"Calculator\\", \\"price\\": 75.00, \\"stock\\":  20},\\n    {\\"name\\": \\"Eraser\\",     \\"price\\":  2.00, \\"stock\\": 200},\\n]\\n\\n# Sort by price\\nby_price = sorted(products, key=lambda p: p[\\"price\\"])\\nprint(\\"By price (cheapest first):\\")\\nfor p in by_price:\\n    print(f\\"  {p[''name'']:<15} {p[''price'']:>7.2f} EGP\\")\\n\\n# Filter: items costing less than 10 EGP\\ncheap = list(filter(lambda p: p[\\"price\\"] < 10, products))\\nprint(f\\"\\\\nUnder 10 EGP: {[p[''name''] for p in cheap]}\\")\\n\\n# TODO: Sort by stock (most in stock first)\\n# TODO: Filter: items with stock > 50\\n# TODO: Create a list of all prices using map() and lambda", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-8-4-challenge', 'lesson-pyl2-8-4', 'exercise', '{"title": "Mission", "instruction": "Given a list of strings representing filenames:\\n[\\"report.pdf\\", \\"notes.txt\\", \\"image.png\\", \\"data.csv\\", \\"backup.txt\\"]\\n1. Sort them alphabetically \\u2014 one line with lambda\\n2. Sort by file extension \\u2014 one line with lambda (Hint: filename.split(\\".\\")[-1])\\n3. Filter to show only .txt files \\u2014 one line with filter + lambda\\n4. Use map + lambda to add \\"2024_\\" prefix to all filenames", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-8-4-quiz', 'lesson-pyl2-8-4', 'quiz', '{"question": "What is the output of `list(map(lambda x: x.upper(), [\\"a\\", \\"b\\", \\"c\\"]))`?", "code": "", "options": [{"id": "A", "text": "`[\\"a\\", \\"b\\", \\"c\\"]`"}, {"id": "B", "text": "`[\\"A\\", \\"B\\", \\"C\\"]`"}, {"id": "C", "text": "`\\"ABC\\"`"}, {"id": "D", "text": "`[True, True, True]`"}], "correct": "B", "explanation": "`map()` applies the lambda to each element. `lambda x: x.upper()` converts each string to uppercase. `list()` converts the map object to a list. Result: `[\\"A\\", \\"B\\", \\"C\\"]`."}', 6);

INSERT INTO exams (id, course_id, chapter_id, title, pass_threshold, exam_type)
VALUES ('exam-pyl2-ch08', 'course-python-level-2', 'chap-pyl2-08', 'Chapter 8 Exam', 60, 'chapter');
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch08-01', 'exam-pyl2-ch08', 'A variable defined inside a function is accessible:', 'MCQ', '[{"id": "A", "text": "Everywhere in the module  B) Only inside that function"}]', 'A', '', 1);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch08-02', 'exam-pyl2-ch08', '`def func(a, b=10, c=20):` — which call is INVALID?', 'MCQ', '[{"id": "A", "text": "`func(1)`  B) `func(1, 2)`  C) `func(b=5, a=1)`  D) `func(b=5, 1)`"}]', 'A', '', 2);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch08-03', 'exam-pyl2-ch08', 'In `def f(*args)`, `args` is of type:', 'MCQ', '[{"id": "A", "text": "list  B) tuple"}]', 'A', '', 3);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch08-04', 'exam-pyl2-ch08', '`sorted(["banana","apple","fig"], key=lambda w: len(w))` returns:', 'MCQ', '[{"id": "A", "text": "`["}]', 'A', '', 4);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch08-05', 'exam-pyl2-ch08', 'Write a function `flexible_average(*numbers, round_to=2)` that accepts any number of values, calculates their average, and rounds it to `round_to` decimal places. Example: `flexible_average(80, 95, 72, 88, round_to=1)` → `83.8`.

---

---', 'Coding', '[]', 'A', '', 5);

INSERT INTO chapters (id, course_id, slug, chapter_number, title, description)
VALUES ('chap-pyl2-09', 'course-python-level-2', 'oop-intro', 9, 'Object-Oriented Programming — Introduction', 'OOP is a different way to organise code. Everything is an object with its own data and behaviour. The most important chapter in Level 2.');

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-9-1', 'course-python-level-2', 'chap-pyl2-09', 'lesson-pyl2-9-1', 1, 'Classes and Objects — The Mental Model', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-9-1-dialogue', 'lesson-pyl2-9-1', 'dialogue', '{"shady": "I''ve been writing functions and data in separate places. There must be a better way to keep related things together. What''s an object? And a class? So the class is like the cookie cutter and objects are the cookies?", "cody": "There is. Object-Oriented Programming. Instead of data over here and functions over there, you bundle them together into an object. Think of a student. A student has data: name, grade, scores. A student can do things: take an exam, get a report card, introduce themselves. That''s an object \\u2014 data AND behaviour, together. The class is the blueprint \\u2014 the definition. ''What does every student have and what can every student do?'' An object is one specific student built from that blueprint. Perfect. Write the cutter once, make infinite cookies."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-9-1-concept', 'lesson-pyl2-9-1', 'concept', '{"title": "A class is a blueprint. An object is something built from that blueprint. Every object has its own data and behaviour.", "body": "The student explains the difference between a class and an object using real-world analogies before writing a single line of OOP code."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-9-1-showcase', 'lesson-pyl2-9-1', 'showcase', '{"title": "Example", "language": "Python", "code": "class Student:\\n    pass    # empty class \\u2014 valid Python\\n\\n# Create two objects from the blueprint\\ns1 = Student()\\ns2 = Student()\\n\\nprint(type(s1))          # <class ''__main__.Student''>\\nprint(s1 == s2)          # False \\u2014 they are different objects\\nprint(isinstance(s1, Student))    # True", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-9-1-playground', 'lesson-pyl2-9-1', 'playground', '{"title": "Playground", "language": "Python", "code": "# Before OOP \\u2014 the messy way\\nnames  = [\\"Ahmed\\", \\"Sara\\", \\"Omar\\"]\\nscores = [95, 88, 72]\\ngrades = [10, 11, 10]\\n\\n# To get Ahmed''s score, I need to remember he''s at index 0\\nprint(f\\"{names[0]}: {scores[0]}\\")    # fragile \\u2014 breaks if list order changes\\n\\n# \\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\n# With OOP (preview \\u2014 we''ll implement __init__ next lesson)\\nclass Student:\\n    pass\\n\\ns = Student()\\ns.name  = \\"Ahmed\\"     # manually adding attributes for now\\ns.score = 95\\ns.grade = 10\\n\\nprint(f\\"{s.name}: {s.score}\\")    # clean \\u2014 data belongs to the object\\n\\n# Create three students\\nstudents = []\\nfor name, score, grade in zip(names, scores, grades):\\n    obj = Student()\\n    obj.name, obj.score, obj.grade = name, score, grade\\n    students.append(obj)\\n\\nfor s in students:\\n    print(f\\"{s.name} (Grade {s.grade}): {s.score}\\")", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-9-1-challenge', 'lesson-pyl2-9-1', 'exercise', '{"title": "Mission", "instruction": "In your own words (written as a comment in Python), explain:\\n1. What is the difference between a class and an object?\\n2. Give TWO real-world examples of a class and what its objects would be\\n3. What is the difference between \\"attributes\\" and \\"methods\\"?\\nThen create a simple class called ''Book'' using pass.\\nCreate 2 Book objects and manually set author, title, and pages on each.\\nPrint a summary of each book.", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-9-1-quiz', 'lesson-pyl2-9-1', 'quiz', '{"question": "If `Car` is a class and `my_car = Car()`, then `my_car` is:", "code": "", "options": [{"id": "A", "text": "The class itself"}, {"id": "B", "text": "A copy of the class"}, {"id": "C", "text": "An instance (object) built from the Car blueprint"}, {"id": "D", "text": "A variable that refers to the Car class"}], "correct": "C", "explanation": "`Car()` creates a new object \\u2014 an instance \\u2014 of the Car class. `my_car` is that specific object. The class is the blueprint; `my_car` is one thing built from that blueprint."}', 6);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-9-2', 'course-python-level-2', 'chap-pyl2-09', 'lesson-pyl2-9-2', 2, '__init__ and Attributes', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-9-2-dialogue', 'lesson-pyl2-9-2', 'dialogue', '{"shady": "Manually setting s.name = ''Ahmed'' after creating the object is messy. Can I provide the name when I create the object \\u2014 like Student(''Ahmed'', 95)? And what''s self? Always self, even if I don''t use it?", "cody": "Yes. That''s what __init__ is for. It runs automatically the moment you call Student(). Whatever arguments you pass \\u2014 __init__ receives them and sets up the object. self is the object itself. When you write self.name = name, you''re saying: ''this particular object''s name attribute = the name I was given.'' Every method needs self as the first parameter \\u2014 always. Always. Python passes it automatically. You just declare it."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-9-2-concept', 'lesson-pyl2-9-2', 'concept', '{"title": "`__init__` is the constructor \\u2014 it automatically runs when an object is created and sets up its initial data. `self` refers to the specific object being created.", "body": "The student writes a class with `__init__`, understands `self`, and creates multiple objects with different data."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-9-2-showcase', 'lesson-pyl2-9-2', 'showcase', '{"title": "Example", "language": "Python", "code": "class Student:\\n    def __init__(self, name, grade, score):\\n        # ''self'' = this specific student object\\n        # These lines create the object''s attributes:\\n        self.name  = name\\n        self.grade = grade\\n        self.score = score\\n\\n# Create objects \\u2014 arguments go to __init__\\ns1 = Student(\\"Ahmed\\", 10, 95)\\ns2 = Student(\\"Sara\\",  11, 88)\\ns3 = Student(\\"Omar\\",  10, 72)\\n\\n# Access attributes with dot notation\\nprint(s1.name)     # Ahmed\\nprint(s2.score)    # 88\\nprint(s3.grade)    # 10", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-9-2-playground', 'lesson-pyl2-9-2', 'playground', '{"title": "Playground", "language": "Python", "code": "class Student:\\n    def __init__(self, name, grade, score):\\n        self.name  = name\\n        self.grade = grade\\n        self.score = score\\n\\n# Create your class roster\\nroster = [\\n    Student(\\"Ahmed\\", 10, 95),\\n    Student(\\"Sara\\",  11, 88),\\n    Student(\\"Omar\\",  10, 72),\\n    Student(\\"Nour\\",  11, 91),\\n    Student(\\"Ali\\",   10, 35),\\n]\\n\\n# Print all students\\nprint(f\\"{''Name'':<12} {''Grade'':>6} {''Score'':>6}\\")\\nprint(\\"\\u2500\\" * 26)\\nfor s in roster:\\n    print(f\\"{s.name:<12} {s.grade:>6} {s.score:>6}\\")\\n\\n# TODO: Find the student with the highest score\\n# Hint: max(roster, key=lambda s: s.score)\\n\\n# TODO: Print only Grade 10 students", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-9-2-challenge', 'lesson-pyl2-9-2', 'exercise', '{"title": "Mission", "instruction": "1. Create a class ''Product'' with attributes: name, price, stock\\n2. Add a default value: stock=0\\n3. Create 4 products \\u2014 at least one with stock=0\\n4. Print all products formatted as: \\"Notebook \\u2014 15.00 EGP (100 in stock)\\"\\n5. Create a list comprehension that returns only products currently in stock (stock > 0)", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-9-2-quiz', 'lesson-pyl2-9-2', 'quiz', '{"question": "Why must `self` always be the first parameter of every method in a class?", "code": "", "options": [{"id": "A", "text": "It''s optional \\u2014 Python works fine without it"}, {"id": "B", "text": "Python automatically passes the object instance as the first argument when a method is called"}, {"id": "C", "text": "`self` stores the class name"}, {"id": "D", "text": "It initialises the object"}], "correct": "B", "explanation": "When you call `s.greet()`, Python translates it to `Student.greet(s)` \\u2014 it passes the object `s` as the first argument automatically. The method receives it as `self`. Without declaring `self`, the method gets the object as an unnamed argument and Python raises a TypeError."}', 6);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-9-3', 'course-python-level-2', 'chap-pyl2-09', 'lesson-pyl2-9-3', 3, 'Methods — Objects That Do Things', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-9-3-dialogue', 'lesson-pyl2-9-3', 'dialogue', '{"shady": "My Student object has data \\u2014 name, score, grade. But it can''t actually DO anything yet. So the function and its data are in the same place.", "cody": "That''s what methods are for. Methods are functions that belong to the class \\u2014 and they can use self. To check if a student is passing \\u2014 self.score >= 50. To introduce themselves \\u2014 use self.name, self.grade. The object has everything it needs. That''s the core idea of OOP. Instead of passing student data to a function, the function lives inside the student and uses its own data."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-9-3-concept', 'lesson-pyl2-9-3', 'concept', '{"title": "Methods are functions defined inside a class. They define what an object can do, using its own data.", "body": "The student adds multiple methods to a class, calls them on objects, and builds a useful Student class."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-9-3-showcase', 'lesson-pyl2-9-3', 'showcase', '{"title": "Example", "language": "Python", "code": "class Student:\\n    def __init__(self, name, grade, score):\\n        self.name  = name\\n        self.grade = grade\\n        self.score = score\\n\\n    def is_passing(self):\\n        return self.score >= 50\\n\\n    def grade_letter(self):\\n        if self.score >= 90: return \\"A\\"\\n        if self.score >= 80: return \\"B\\"\\n        if self.score >= 70: return \\"C\\"\\n        if self.score >= 60: return \\"D\\"\\n        return \\"F\\"\\n\\n    def introduce(self):\\n        status = \\"passing\\" if self.is_passing() else \\"failing\\"\\n        return (f\\"Hi! I''m {self.name}, Grade {self.grade}. \\"\\n                f\\"My score is {self.score}/100 \\u2014 grade {self.grade_letter()}. \\"\\n                f\\"Currently {status}.\\")\\n\\n    def apply_bonus(self, points):\\n        self.score = min(100, self.score + points)\\n        return self.score", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-9-3-playground', 'lesson-pyl2-9-3', 'playground', '{"title": "Playground", "language": "Python", "code": "class Student:\\n    def __init__(self, name, grade, score):\\n        self.name  = name\\n        self.grade = grade\\n        self.score = score\\n\\n    def is_passing(self):\\n        return self.score >= 50\\n\\n    def grade_letter(self):\\n        # TODO: Implement grade_letter (A/B/C/D/F)\\n        pass\\n\\n    def status_report(self):\\n        # TODO: Return a formatted string with name, score, letter, and pass/fail\\n        pass\\n\\n    def __str__(self):\\n        return f\\"{self.name}: {self.score}/100\\"\\n\\n# Test your methods\\nstudents = [\\n    Student(\\"Ahmed\\", 10, 95),\\n    Student(\\"Sara\\",  11, 42),\\n    Student(\\"Omar\\",  10, 78),\\n]\\n\\nfor s in students:\\n    print(s)\\n    print(f\\"  Passing: {s.is_passing()}\\")\\n    print(f\\"  Report:  {s.status_report()}\\")\\n    print()", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-9-3-challenge', 'lesson-pyl2-9-3', 'exercise', '{"title": "Mission", "instruction": "Add these methods to the Student class:\\n1. add_score(subject, score) \\u2014 store subject scores in a dict: self.subject_scores\\n2. average() \\u2014 return the average of all subject scores\\n3. best_subject() \\u2014 return the subject with the highest score\\n4. full_report() \\u2014 return a formatted multi-line string showing all subjects, average, and status\\nTest with at least 3 subjects per student", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-9-3-quiz', 'lesson-pyl2-9-3', 'quiz', '{"question": "You call `student.introduce()`. How does the method get access to `self.name`?", "code": "", "options": [{"id": "A", "text": "`self.name` is a global variable"}, {"id": "B", "text": "`name` is passed as an argument when calling `introduce()`"}, {"id": "C", "text": "Python automatically passes the object as `self` \\u2014 so `self.name` is this student''s name"}, {"id": "D", "text": "All methods share one common `self` object"}], "correct": "C", "explanation": "When you call `student.introduce()`, Python translates it to `Student.introduce(student)`. Inside the method, `self` is `student` \\u2014 so `self.name` is `student.name`. Each object''s method call uses that specific object''s data."}', 6);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-9-4', 'course-python-level-2', 'chap-pyl2-09', 'lesson-pyl2-9-4', 4, 'Mini Project — Class Roster System', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-9-4-dialogue', 'lesson-pyl2-9-4', 'dialogue', '{"shady": "Can classes work together? Like a Classroom that contains Students? The objects talk to each other.", "cody": "That''s exactly how OOP scales. One class manages objects of another class. A Classroom holds a list of Student objects. When you call classroom.add_student(), it creates a Student and stores it. When you call classroom.report(), it loops through all Student objects and calls their own methods. That''s OOP in practice. Let''s build it."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-9-4-concept', 'lesson-pyl2-9-4', 'concept', '{"title": "Build a complete system using OOP: a `Student` class and a `Classroom` class that manages a roster of Student objects.", "body": "The student implements two interacting classes with multiple methods to build a functional class roster system."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-9-4-showcase', 'lesson-pyl2-9-4', 'showcase', '{"title": "Example", "language": "Python", "code": "class Student:\\n    def __init__(self, name, grade, score):\\n        self.name  = name\\n        self.grade = grade\\n        self.score = score\\n\\n    def is_passing(self):    return self.score >= 50\\n\\n    def grade_letter(self):\\n        for threshold, letter in [(90,\\"A\\"),(80,\\"B\\"),(70,\\"C\\"),(60,\\"D\\")]:\\n            if self.score >= threshold:\\n                return letter\\n        return \\"F\\"\\n\\n    def __str__(self):\\n        return (f\\"{self.name:<15} Grade {self.grade}  \\"\\n                f\\"{self.score:>3}/100  {self.grade_letter()}  \\"\\n                f\\"{''\\u2714'' if self.is_passing() else ''\\u2718''}\\")\\n\\n\\nclass Classroom:\\n    def __init__(self, class_name, teacher):\\n        self.class_name = class_name\\n        self.teacher    = teacher\\n        self.students   = []        # list of Student objects\\n\\n    def add_student(self, name, grade, score):\\n        student = Student(name, grade, score)\\n        self.students.append(student)\\n        print(f\\"  Added: {name}\\")\\n\\n    def find_student(self, name):\\n        for s in self.students:\\n            if s.name.lower() == name.lower():\\n                return s\\n        return None\\n\\n    def remove_student(self, name):\\n        s = self.find_student(name)\\n        if s:\\n            self.students.remove(s)\\n            print(f\\"  Removed: {name}\\")\\n        else:\\n            print(f\\"  ''{name}'' not found.\\")\\n\\n    def class_average(self):\\n        if not self.students:\\n            return 0\\n        return sum(s.score for s in self.students) / len(self.students)\\n\\n    def top_students(self, n=3):\\n        return sorted(self.students, key=lambda s: s.score, reverse=True)[:n]\\n\\n    def print_report(self):\\n        print(f\\"\\\\n{''\\u2550''*55}\\")\\n        print(f\\"  Class: {self.class_name}  |  Teacher: {self.teacher}\\")\\n        print(f\\"{''\\u2550''*55}\\")\\n        print(f\\"  {''Name'':<15} {''Grade'':>6} {''Score'':>7} {''Ltr'':>4} {''OK'':>4}\\")\\n        print(f\\"  {''\\u2500''*50}\\")\\n        for s in sorted(self.students, key=lambda x: x.score, reverse=True):\\n            print(f\\"  {s}\\")\\n        print(f\\"  {''\\u2500''*50}\\")\\n        avg = self.class_average()\\n        passed = sum(1 for s in self.students if s.is_passing())\\n        print(f\\"  Students: {len(self.students)}  \\"\\n              f\\"Passed: {passed}  \\"\\n              f\\"Failed: {len(self.students)-passed}  \\"\\n              f\\"Average: {avg:.1f}\\")\\n        print(f\\"{''\\u2550''*55}\\")\\n\\n        if self.students:\\n            top = self.top_students(1)[0]\\n            print(f\\"\\\\n  \\ud83c\\udfc6 Top student: {top.name} ({top.score}/100)\\\\n\\")\\n\\n\\n# \\u2500\\u2500 Demo \\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\nroom = Classroom(\\"10-A\\", \\"Mr. Cody\\")\\nroom.add_student(\\"Ahmed\\", 10, 95)\\nroom.add_student(\\"Sara\\",  10, 42)\\nroom.add_student(\\"Omar\\",  10, 78)\\nroom.add_student(\\"Nour\\",  10, 88)\\nroom.add_student(\\"Ali\\",   10, 35)\\nroom.add_student(\\"Maya\\",  10, 91)\\n\\nroom.print_report()\\n\\n# Look up a student\\ns = room.find_student(\\"omar\\")\\nif s:\\n    print(f\\"\\\\nFound: {s.name} \\u2014 Grade letter: {s.grade_letter()}\\")\\n\\n# Remove one\\nroom.remove_student(\\"Ali\\")\\nprint(f\\"\\\\nAfter removal \\u2014 Students: {len(room.students)}\\")", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-9-4-playground', 'lesson-pyl2-9-4', 'playground', '{"title": "Playground", "language": "Python", "code": "class Student:\\n    def __init__(self, name, score):\\n        self.name  = name\\n        self.score = score\\n\\n    def is_passing(self):\\n        return self.score >= 50\\n\\n    def __str__(self):\\n        return f\\"{self.name}: {self.score} ({''Pass'' if self.is_passing() else ''Fail''})\\"\\n\\n\\nclass Classroom:\\n    def __init__(self):\\n        self.students = []\\n\\n    def add(self, name, score):\\n        self.students.append(Student(name, score))\\n\\n    def average(self):\\n        # TODO: Return the class average\\n        pass\\n\\n    def report(self):\\n        # TODO: Print all students using __str__\\n        # TODO: Print the class average\\n        pass\\n\\n\\nroom = Classroom()\\nroom.add(\\"Ahmed\\", 95)\\nroom.add(\\"Sara\\", 42)\\nroom.add(\\"Omar\\", 78)\\nroom.report()", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-9-4-challenge', 'lesson-pyl2-9-4', 'exercise', '{"title": "Mission", "instruction": "Extend the Classroom class:\\n1. Add a method grade_distribution() that returns a dict:\\n   {\\"A\\": 2, \\"B\\": 1, \\"C\\": 0, \\"D\\": 1, \\"F\\": 1}\\n   (count how many students got each letter grade)\\n2. Add apply_bonus(points) that adds points to every failing student''s score\\n3. Add to_csv(filename) that saves the roster to a CSV file\\n   (reuse your file writing skills from Chapter 4)", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-9-4-quiz', 'lesson-pyl2-9-4', 'quiz', '{"question": "In the Classroom class, `self.students.append(Student(name, grade, score))` does what?", "code": "", "options": [{"id": "A", "text": "Prints the student''s data"}, {"id": "B", "text": "Creates a new Student object and adds it to the Classroom''s list of students"}, {"id": "C", "text": "Adds a copy of the Classroom to the Student"}, {"id": "D", "text": "Raises a NameError \\u2014 Student is not defined"}], "correct": "B", "explanation": "`Student(name, grade, score)` creates a new Student object (calls `__init__`). `self.students.append(...)` adds that object to the classroom''s list. This is how one class manages a collection of another class''s objects."}', 6);

INSERT INTO exams (id, course_id, chapter_id, title, pass_threshold, exam_type)
VALUES ('exam-pyl2-ch09', 'course-python-level-2', 'chap-pyl2-09', 'Chapter 9 Exam', 60, 'chapter');
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch09-01', 'exam-pyl2-ch09', 'What is the difference between a class and an instance?', 'MCQ', '[{"id": "A", "text": "No difference \\u2014 they''re the same  B) A class is the blueprint; an instance is an object built from it"}]', 'A', '', 1);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch09-02', 'exam-pyl2-ch09', 'Why does every method in a class need `self` as the first parameter?', 'MCQ', '[{"id": "A", "text": "It''s just convention \\u2014 can be omitted  B) Python passes the object automatically as the first argument"}]', 'A', '', 2);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch09-03', 'exam-pyl2-ch09', '`def __str__(self):` is used for:', 'MCQ', '[{"id": "A", "text": "Comparing two objects  B) Deleting the object  C) Defining what `print(object)` displays"}]', 'A', '', 3);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch09-04', 'exam-pyl2-ch09', 'Which correctly creates a Student with name "Ahmed" and score 95?', 'MCQ', '[{"id": "A", "text": "`Student = ("}]', 'A', '', 4);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch09-05', 'exam-pyl2-ch09', 'Write a `BankAccount` class with: `__init__(self, owner, balance=0)`, `deposit(self, amount)`, `withdraw(self, amount)` (reject if insufficient funds), `__str__` showing owner and balance. Create two accounts, deposit and withdraw, and print both.', 'Coding', '[]', 'A', '', 5);
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch09-06', 'exam-pyl2-ch09', 'Add a class method `class_average(students)` to the Student class (or standalone function) that takes a list of Student objects and returns the average score. Use it to find the class average for a roster of 5 students.

---

---', 'Coding', '[]', 'A', '', 6);

INSERT INTO chapters (id, course_id, slug, chapter_number, title, description)
VALUES ('chap-pyl2-10', 'course-python-level-2', 'capstone', 10, 'Capstone — Building a Real Python Project', 'Apply everything from Level 2 to build a complete Student Management System.');

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-10-1', 'course-python-level-2', 'chap-pyl2-10', 'lesson-pyl2-10-1', 1, 'Project Planning', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-10-1-dialogue', 'lesson-pyl2-10-1', 'dialogue', '{"shady": "I want to build a proper Student Management System \\u2014 not just practice code. Something that could actually be used. What do we plan?", "cody": "Then let''s plan it properly. Professional programmers spend real time planning before touching a keyboard. A clear plan catches most problems in 10 minutes instead of discovering them 3 hours into coding. Requirements \\u2014 what must it do? Classes \\u2014 what objects exist and what data do they hold? Methods \\u2014 what can each object do? Data flow \\u2014 how does information move through the system? Persistence \\u2014 what gets saved and how?"}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-10-1-concept', 'lesson-pyl2-10-1', 'concept', '{"title": "Real projects are designed before they''re coded. Planning prevents wasted effort and reveals problems early.", "body": "The student plans a multi-class project by identifying requirements, classes, methods, and data flow before writing code."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-10-1-showcase', 'lesson-pyl2-10-1', 'showcase', '{"title": "Example", "language": "Python", "code": "# Class: Student\\n#   Attributes: name, grade, scores (list)\\n#   Methods: add_score(), average(), grade_letter(),\\n#            is_passing(), status_report(), __str__\\n\\n# Class: Classroom\\n#   Attributes: name, teacher, students (list of Student objects)\\n#   Methods: add_student(), find_student(), remove_student(),\\n#            class_average(), top_students(), failing_students(),\\n#            print_report(), save_to_file(), load_from_file()", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-10-1-playground', 'lesson-pyl2-10-1', 'playground', '{"title": "Playground", "language": "Python", "code": "# Planning document \\u2014 write this BEFORE the code\\n\\n\\"\\"\\"\\nPROJECT: Student Management System\\nDEVELOPER: [Your name]\\nDATE: [Today]\\n\\nCLASSES:\\n\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\nStudent:\\n  init: name (str), grade (int), scores (list = [])\\n  Methods:\\n    add_score(score)     \\u2014 validates and adds to self.scores\\n    average()            \\u2014 returns mean of scores, or 0 if empty\\n    grade_letter()       \\u2014 A/B/C/D/F based on average\\n    is_passing()         \\u2014 average >= 50\\n    status_report()      \\u2014 formatted string summary\\n    __str__()            \\u2014 \\"Ahmed (Grade 10) \\u2014 Avg: 85.3 [B]\\"\\n\\nClassroom:\\n  init: class_name, teacher, students=[]\\n  Methods:\\n    add_student(name, grade, *scores)\\n    find_student(name)       \\u2014 case-insensitive search\\n    remove_student(name)\\n    class_average()\\n    top_students(n=3)\\n    failing_students()\\n    print_report()\\n    save_to_file(filename)\\n    load_from_file(filename)\\n\\nERRORS TO HANDLE:\\n\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\n  File not found on startup \\u2192 start with empty roster\\n  Invalid score input \\u2192 ask again\\n  Student not found \\u2192 friendly message, no crash\\n  Empty roster \\u2192 \\"No students\\" message in report\\n\\"\\"\\"\\n\\nprint(\\"Plan written. Now let''s build it.\\")", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-10-1-challenge', 'lesson-pyl2-10-1', 'exercise', '{"title": "Mission", "instruction": "Write the full planning document for the SMS in a Python file as a docstring or comments.\\nInclude:\\n1. All requirements (at least 8)\\n2. Both class designs with all attributes and methods listed\\n3. The file format you''ll use\\n4. Three error cases you''ll handle\\n5. What Level 3 could add on top of this (APIs, web interface, database, etc.)\\nThis document becomes the blueprint for the next 3 lessons.", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-10-1-quiz', 'lesson-pyl2-10-1', 'quiz', '{"question": "Why is time spent planning before coding considered professional practice, not wasted time?", "code": "", "options": [{"id": "A", "text": "Companies require documentation for legal reasons"}, {"id": "B", "text": "Planning reveals design problems early \\u2014 when they''re cheap to fix in comments, not expensive to fix in code"}, {"id": "C", "text": "Clients want to see planning documents"}, {"id": "D", "text": "Python requires a plan file before running"}], "correct": "B", "explanation": "Problems found in a plan take seconds to fix (edit the comment). Problems found after coding take hours to fix (refactor the code). The earlier you find a problem, the cheaper it is."}', 6);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-10-2', 'course-python-level-2', 'chap-pyl2-10', 'lesson-pyl2-10-2', 2, 'Building the Core — Student and Classroom Classes', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-10-2-dialogue', 'lesson-pyl2-10-2', 'dialogue', '{"shady": "We have the plan. Let''s code.", "cody": "We''ll build from the inside out. Student class first \\u2014 it doesn''t depend on anything. Classroom next \\u2014 it uses Student objects. File I/O last \\u2014 it uses both. Test each layer before building the next."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-10-2-concept', 'lesson-pyl2-10-2', 'concept', '{"title": "Implement the planned classes from Lesson 10.1 with all core methods.", "body": "The student builds working Student and Classroom classes, integrating everything from Chapters 8 and 9."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-10-2-showcase', 'lesson-pyl2-10-2', 'showcase', '{"title": "Example", "language": "Python", "code": "# \\u2500\\u2500 student.py (or include inline) \\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\nclass Student:\\n    def __init__(self, name, grade, scores=None):\\n        self.name   = name\\n        self.grade  = int(grade)\\n        self.scores = scores if scores is not None else []\\n\\n    def add_score(self, score):\\n        try:\\n            s = float(score)\\n            if 0 <= s <= 100:\\n                self.scores.append(s)\\n                return True\\n            else:\\n                print(f\\"  Score must be 0-100, got {s}\\")\\n                return False\\n        except (ValueError, TypeError):\\n            print(f\\"  Invalid score: {score!r}\\")\\n            return False\\n\\n    def average(self):\\n        return sum(self.scores) / len(self.scores) if self.scores else 0\\n\\n    def grade_letter(self):\\n        avg = self.average()\\n        for threshold, letter in [(90,\\"A\\"),(80,\\"B\\"),(70,\\"C\\"),(60,\\"D\\")]:\\n            if avg >= threshold:\\n                return letter\\n        return \\"F\\"\\n\\n    def is_passing(self):\\n        return self.average() >= 50\\n\\n    def status_report(self):\\n        scores_str = \\", \\".join(f\\"{s:.0f}\\" for s in self.scores) or \\"No scores\\"\\n        return (f\\"{''\\u2500''*40}\\\\n\\"\\n                f\\"  Name:    {self.name}\\\\n\\"\\n                f\\"  Grade:   {self.grade}\\\\n\\"\\n                f\\"  Scores:  {scores_str}\\\\n\\"\\n                f\\"  Average: {self.average():.1f}\\\\n\\"\\n                f\\"  Letter:  {self.grade_letter()}\\\\n\\"\\n                f\\"  Status:  {''Passing \\u2714'' if self.is_passing() else ''Failing \\u2718''}\\")\\n\\n    def __str__(self):\\n        return (f\\"{self.name:<15} Gr.{self.grade}  \\"\\n                f\\"Avg:{self.average():5.1f}  \\"\\n                f\\"{self.grade_letter()}  \\"\\n                f\\"{''\\u2714'' if self.is_passing() else ''\\u2718''}\\")", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-10-2-playground', 'lesson-pyl2-10-2', 'playground', '{"title": "Playground", "language": "Python", "code": "# Test Student class thoroughly before building Classroom\\nclass Student:\\n    def __init__(self, name, grade, scores=None):\\n        self.name   = name\\n        self.grade  = int(grade)\\n        self.scores = scores if scores else []\\n\\n    def add_score(self, score):\\n        self.scores.append(float(score))\\n\\n    def average(self):\\n        return sum(self.scores) / len(self.scores) if self.scores else 0\\n\\n    def grade_letter(self):\\n        avg = self.average()\\n        for t, l in [(90,\\"A\\"),(80,\\"B\\"),(70,\\"C\\"),(60,\\"D\\")]:\\n            if avg >= t: return l\\n        return \\"F\\"\\n\\n    def is_passing(self): return self.average() >= 50\\n\\n    def __str__(self):\\n        return f\\"{self.name} \\u2014 Avg: {self.average():.1f} [{self.grade_letter()}]\\"\\n\\n# \\u2500\\u2500 Tests \\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\ns = Student(\\"Ahmed\\", 10)\\ns.add_score(85)\\ns.add_score(92)\\ns.add_score(78)\\nprint(s)\\nprint(f\\"Passing: {s.is_passing()}\\")\\n\\ns2 = Student(\\"Sara\\", 11, [42, 38, 55])\\nprint(s2)\\nprint(f\\"Passing: {s2.is_passing()}\\")", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-10-2-challenge', 'lesson-pyl2-10-2', 'exercise', '{"title": "Mission", "instruction": "Implement the Classroom class with at least:\\n1. __init__(self, class_name, teacher)\\n2. add_student(name, grade, *scores)\\n3. find_student(name) \\u2014 case-insensitive\\n4. remove_student(name)\\n5. class_average()\\n6. print_report()\\nTest it with at least 5 students", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-10-3', 'course-python-level-2', 'chap-pyl2-10', 'lesson-pyl2-10-3', 3, 'File I/O and Full System Integration', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-10-3-dialogue', 'lesson-pyl2-10-3', 'dialogue', '{"shady": "The classes work. But if I restart, everything''s gone again. What about all the places where the user could crash the program?", "cody": "File I/O \\u2014 the last piece. Save on exit, load on start. We''ll use CSV and os.path.exists to handle the first run. try/except around every user input. The get_int() and get_float() functions from Chapter 6. Import datetime to timestamp the report. Everything you''ve learned \\u2014 all in one program."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-10-3-concept', 'lesson-pyl2-10-3', 'concept', '{"title": "Add persistence (save/load) and error handling to complete the Student Management System.", "body": "The student adds file I/O to the Classroom class and wraps the whole system in a menu-driven main loop."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-10-3-showcase', 'lesson-pyl2-10-3', 'showcase', '{"title": "Example", "language": "Python", "code": "import csv, os, datetime\\nfrom safe_input import get_int, get_float, get_non_empty_string   # ch.6 utility\\n\\nFILENAME = \\"classroom_data.csv\\"\\n\\nclass Classroom:\\n    # ... (add_student, find_student, etc. from 10.2)\\n\\n    def save_to_file(self, filename=FILENAME):\\n        with open(filename, \\"w\\", newline=\\"\\") as f:\\n            writer = csv.writer(f)\\n            writer.writerow([\\"name\\", \\"grade\\", \\"scores\\"])\\n            for s in self.students:\\n                scores_str = \\",\\".join(str(sc) for sc in s.scores)\\n                writer.writerow([s.name, s.grade, scores_str])\\n        print(f\\"  Saved {len(self.students)} students to {filename}\\")\\n\\n    def load_from_file(self, filename=FILENAME):\\n        if not os.path.exists(filename):\\n            return\\n        try:\\n            with open(filename, \\"r\\") as f:\\n                reader = csv.reader(f)\\n                next(reader)    # skip header\\n                for row in reader:\\n                    if len(row) >= 2:\\n                        name, grade = row[0], row[1]\\n                        scores = [float(x) for x in row[2].split(\\",\\") if x] if len(row) > 2 else []\\n                        self.students.append(Student(name, grade, scores))\\n            print(f\\"  Loaded {len(self.students)} students from {filename}\\")\\n        except Exception as e:\\n            print(f\\"  Load error: {e}\\")\\n\\n\\n# \\u2500\\u2500 Main application \\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\u2500\\ndef main():\\n    room = Classroom(\\"10-A\\", \\"Mr. Cody\\")\\n    room.load_from_file()\\n\\n    menu = \\"\\"\\"\\n\\u2554\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2557\\n\\u2551  Student Management SMS   \\u2551\\n\\u2560\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2563\\n\\u2551  1. Add student           \\u2551\\n\\u2551  2. Look up student       \\u2551\\n\\u2551  3. Add scores            \\u2551\\n\\u2551  4. Remove student        \\u2551\\n\\u2551  5. Class report          \\u2551\\n\\u2551  6. Top students          \\u2551\\n\\u2551  7. Failing students      \\u2551\\n\\u2551  8. Save & exit           \\u2551\\n\\u255a\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u2550\\u255d\\"\\"\\"\\n\\n    while True:\\n        print(menu)\\n        choice = input(\\"Choice (1-8): \\").strip()\\n\\n        if choice == \\"1\\":\\n            name  = get_non_empty_string(\\"  Name: \\")\\n            grade = get_int(\\"  Grade (1-12): \\", 1, 12)\\n            student = room.add_student(name, grade)\\n\\n        elif choice == \\"2\\":\\n            name = input(\\"  Name: \\").strip()\\n            s = room.find_student(name)\\n            if s: print(s.status_report())\\n            else: print(f\\"  ''{name}'' not found.\\")\\n\\n        elif choice == \\"3\\":\\n            name = input(\\"  Student name: \\").strip()\\n            s = room.find_student(name)\\n            if s:\\n                score = get_float(\\"  Score (0-100): \\", 0, 100)\\n                s.add_score(score)\\n                print(f\\"  New average: {s.average():.1f}\\")\\n            else:\\n                print(f\\"  ''{name}'' not found.\\")\\n\\n        elif choice == \\"4\\":\\n            name = input(\\"  Name to remove: \\").strip()\\n            room.remove_student(name)\\n\\n        elif choice == \\"5\\":\\n            room.print_report()\\n\\n        elif choice == \\"6\\":\\n            n = get_int(\\"  How many top students? \\", 1, len(room.students) or 1)\\n            for i, s in enumerate(room.top_students(n), 1):\\n                print(f\\"  #{i} {s}\\")\\n\\n        elif choice == \\"7\\":\\n            failing = room.failing_students()\\n            if failing:\\n                print(f\\"  Failing ({len(failing)}):\\")\\n                for s in failing: print(f\\"    {s}\\")\\n            else:\\n                print(\\"  All students are passing!\\")\\n\\n        elif choice == \\"8\\":\\n            room.save_to_file()\\n            print(f\\"\\\\n  Saved at {datetime.datetime.now().strftime(''%H:%M:%S'')}\\")\\n            print(\\"  Goodbye!\\")\\n            break\\n\\n        else:\\n            print(\\"  Invalid choice \\u2014 1 to 8.\\")\\n\\nmain()", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-10-3-playground', 'lesson-pyl2-10-3', 'playground', '{"title": "Playground", "language": "Python", "code": "", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-10-3-challenge', 'lesson-pyl2-10-3', 'exercise', '{"title": "Mission", "instruction": "Add two more features to the system:\\n1. Export report to a text file (choice 9):\\n   - Same content as print_report() but written to \\"report_YYYY-MM-DD.txt\\"\\n   - Include a timestamp in the file header\\n2. Show grade distribution (choice 10):\\n   - How many A, B, C, D, F grades in the class\\n   - Show as both counts and percentages\\n   - Bonus: show a text bar chart using \\u2593 characters", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);

INSERT INTO lessons (id, course_id, chapter_id, slug, lesson_number, title, duration_minutes, xp_reward)
VALUES ('lesson-pyl2-10-4', 'course-python-level-2', 'chap-pyl2-10', 'lesson-pyl2-10-4', 4, 'Polish and What''s Next', 22, 25);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-10-4-dialogue', 'lesson-pyl2-10-4', 'dialogue', '{"shady": "I built a real program. Not practice code \\u2014 a real program. What''s Level 3?", "cody": "Run it. Does it work? That''s the difference between code that works in theory and code that works in production. You added error handling. You added validation. The program is resilient. You did. And more importantly \\u2014 you understand everything in it. Every line. Every class. Every file operation. That''s what Level 2 was for. The same solid foundation \\u2014 applied to bigger things."}', 1);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-10-4-concept', 'lesson-pyl2-10-4', 'concept', '{"title": "Final refinements, reflection on everything learned, and a clear preview of what Level 3 adds.", "body": "The student completes, tests, and reflects on the capstone project, and understands what Python mastery looks like next."}', 2);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-10-4-showcase', 'lesson-pyl2-10-4', 'showcase', '{"title": "Example", "language": "Python", "code": "\\"\\"\\"\\nPYTHON FOUNDATIONS \\u2014 LEVEL 2 \\u2014 COMPLETE\\n\\nCh.1  Strings Deep Dive\\n      \\u2192 slicing, all methods, formatting, text analyser\\n\\nCh.2  Dictionaries\\n      \\u2192 key-value pairs, .get(), .items(), grade book\\n\\nCh.3  Tuples and Sets\\n      \\u2192 immutability, set operations, choosing structures\\n\\nCh.4  File I/O\\n      \\u2192 read/write/append, CSV, persistent data\\n\\nCh.5  Modules\\n      \\u2192 math, random, datetime, os, import styles\\n\\nCh.6  Error Handling\\n      \\u2192 try/except, finally, raise, bulletproof input\\n\\nCh.7  Comprehensions\\n      \\u2192 list, dict, set comprehensions, filtering\\n\\nCh.8  Advanced Functions\\n      \\u2192 scope, default args, *args/**kwargs, lambda\\n\\nCh.9  OOP Introduction\\n      \\u2192 classes, objects, __init__, self, methods\\n\\nCh.10 Capstone\\n      \\u2192 Student Management System using everything above\\n\\"\\"\\"", "explanation": "Study the example and try it in the playground."}', 3);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-10-4-playground', 'lesson-pyl2-10-4', 'playground', '{"title": "Playground", "language": "Python", "code": "# Final checklist \\u2014 test your complete SMS against these cases\\n\\ntest_cases = [\\n    (\\"Add valid student\\",     \\"Normal operation \\u2014 should work\\"),\\n    (\\"Add student duplicate\\", \\"Should handle gracefully\\"),\\n    (\\"Look up missing name\\",  \\"Should say ''not found'', not crash\\"),\\n    (\\"Score = 101\\",           \\"Should reject with message\\"),\\n    (\\"Score = ''hello''\\",       \\"Should ask again\\"),\\n    (\\"Empty roster report\\",   \\"Should print ''No students''\\"),\\n    (\\"Save and reload\\",       \\"Data should persist between runs\\"),\\n    (\\"Remove last student\\",   \\"Roster becomes empty \\u2014 all functions still work\\"),\\n]\\n\\nprint(\\"Run your SMS and test each scenario below:\\")\\nfor i, (test, expected) in enumerate(test_cases, 1):\\n    print(f\\"  {i:2}. Test: {test}\\")\\n    print(f\\"       Expected: {expected}\\")\\n    print()", "instruction": "Edit the values freely and press Run Code to experiment."}', 4);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-10-4-challenge', 'lesson-pyl2-10-4', 'exercise', '{"title": "Mission", "instruction": "Write the final version of your Student Management System that:\\n1. Passes ALL 8 test cases from the playground above\\n2. Has at least 10 choices in the menu\\n3. Saves data persistently between sessions\\n4. Never crashes on any user input\\n5. Has a properly formatted class report with aligned columns\\nSubmit the complete, working program as your Level 2 Capstone.", "language": "Python", "initialCode": "# Write your solution here\\n", "solutionCode": "", "expectedOutput": ""}', 5);
INSERT INTO lesson_blocks (id, lesson_id, block_type, content, block_order)
VALUES ('lesson-pyl2-10-4-quiz', 'lesson-pyl2-10-4', 'quiz', '{"question": "You built the SMS in Python using OOP, file I/O, and error handling. What makes it a \\"real program\\" rather than just practice code?", "code": "", "options": [{"id": "A", "text": "It has more than 100 lines"}, {"id": "B", "text": "It uses classes"}, {"id": "C", "text": "It persists data, handles all user errors gracefully, and solves a genuine real-world problem"}, {"id": "D", "text": "It imports modules"}], "correct": "C", "explanation": "A \\"real program\\" is defined by its reliability and usefulness, not its length. Persistence (data survives restarts), robustness (no crashes from bad input), and solving a real problem \\u2014 those are the marks of production-quality code."}', 6);

INSERT INTO exams (id, course_id, chapter_id, title, pass_threshold, exam_type)
VALUES ('exam-pyl2-ch10', 'course-python-level-2', 'chap-pyl2-10', 'Chapter 10 Exam', 60, 'chapter');
INSERT INTO exam_questions (id, exam_id, question_text, question_type, options_json, correct_answer, explanation, question_order)
VALUES ('q-ch10-01', 'exam-pyl2-ch10', 'What makes a Python program "production-quality"?', 'MCQ', '[{"id": "A", "text": "It has more than 100 lines of code"}, {"id": "B", "text": "It uses classes and OOP"}, {"id": "C", "text": "It persists data, handles all user errors gracefully, and solves a genuine problem"}, {"id": "D", "text": "It imports many modules"}]', 'C', 'A real program is defined by reliability and usefulness: persistence, robustness, and solving a genuine problem.', 1);

-- ── Done ────────────────────────────────────────────────────
-- Python Level 2 rebuilt: 10 chapters, 40 lessons
-- ─────────────────────────────────────────────────────────────


INSERT INTO questions (id, question_text, question_type, options_json, points)
VALUES ('98bd726a-2a19-5d4d-862b-356a26b70848', 'Which structure is most appropriate for many student records where each record has named fields?', 'multiple_choice', '{"options":["A list of dictionaries","One integer","One string only","A single boolean"]}', 10);
INSERT INTO question_answer_keys (id, question_id, correct_answer, explanation)
VALUES ('f2edc2da-f8b5-5da4-9187-650bbea24a77', '98bd726a-2a19-5d4d-862b-356a26b70848', '{"correct_index":0,"correct_value":"A list of dictionaries"}', 'See chapter lessons for the underlying concept.');
INSERT INTO exam_questions (id, exam_id, question_id, order_index)
VALUES ('aadd08ba-6a5e-51f2-8219-6626ff3bde81', '6b7213e2-f576-5665-aa80-50923075da59', '98bd726a-2a19-5d4d-862b-356a26b70848', 1);


INSERT INTO questions (id, question_text, question_type, options_json, points)
VALUES ('14810eee-eeb5-5440-a567-c9b97200b33f', 'Why should a program separate responsibilities into functions?', 'multiple_choice', '{"options":["To make code easier to understand, test, reuse, and maintain","To make every program longer","To avoid variables","To remove the need for testing"]}', 10);
INSERT INTO question_answer_keys (id, question_id, correct_answer, explanation)
VALUES ('dfe777c8-8a3f-5d65-ab38-67e9f74715d9', '14810eee-eeb5-5440-a567-c9b97200b33f', '{"correct_index":0,"correct_value":"To make code easier to understand, test, reuse, and maintain"}', 'See chapter lessons for the underlying concept.');
INSERT INTO exam_questions (id, exam_id, question_id, order_index)
VALUES ('8408ece3-d594-5ccc-91bc-70afce0e0dec', '6b7213e2-f576-5665-aa80-50923075da59', '14810eee-eeb5-5440-a567-c9b97200b33f', 2);


INSERT INTO questions (id, question_text, question_type, options_json, points)
VALUES ('6f550cbf-dcd5-5795-8013-cc7a60a48382', 'Which mode appends text to a file?', 'multiple_choice', '{"options":["r","w","a","x"]}', 10);
INSERT INTO question_answer_keys (id, question_id, correct_answer, explanation)
VALUES ('747767ed-5f08-5e06-bc04-5080b65b67c2', '6f550cbf-dcd5-5795-8013-cc7a60a48382', '{"correct_index":2,"correct_value":"a"}', 'See chapter lessons for the underlying concept.');
INSERT INTO exam_questions (id, exam_id, question_id, order_index)
VALUES ('952f17a9-3c52-5e05-833b-de00cd16ea61', '6b7213e2-f576-5665-aa80-50923075da59', '6f550cbf-dcd5-5795-8013-cc7a60a48382', 3);


INSERT INTO questions (id, question_text, question_type, options_json, points)
VALUES ('bb66320b-864f-580f-88c0-a5d8ec43265d', 'What is the main purpose of try/except?', 'multiple_choice', '{"options":["Handle expected exceptions and keep the program''s normal flow under control","Hide all bugs","Replace functions","Create objects"]}', 10);
INSERT INTO question_answer_keys (id, question_id, correct_answer, explanation)
VALUES ('f33f04b1-2258-5127-8cb0-c0afeeadde8b', 'bb66320b-864f-580f-88c0-a5d8ec43265d', '{"correct_index":0,"correct_value":"Handle expected exceptions and keep the program''s normal flow under control"}', 'See chapter lessons for the underlying concept.');
INSERT INTO exam_questions (id, exam_id, question_id, order_index)
VALUES ('c0fc538b-e0be-5b52-9305-2be23060077e', '6b7213e2-f576-5665-aa80-50923075da59', 'bb66320b-864f-580f-88c0-a5d8ec43265d', 4);


INSERT INTO questions (id, question_text, question_type, options_json, points)
VALUES ('9f7e776d-f1bc-5d3a-b8cc-43061e3afff0', 'What is the relationship between a class and an object?', 'multiple_choice', '{"options":["A class is a blueprint; an object is an instance created from it","They are unrelated","An object is always a module","A class can only contain numbers"]}', 10);
INSERT INTO question_answer_keys (id, question_id, correct_answer, explanation)
VALUES ('db0d3698-5318-501e-a80f-e795b73fa28a', '9f7e776d-f1bc-5d3a-b8cc-43061e3afff0', '{"correct_index":0,"correct_value":"A class is a blueprint; an object is an instance created from it"}', 'See chapter lessons for the underlying concept.');
INSERT INTO exam_questions (id, exam_id, question_id, order_index)
VALUES ('831bbabe-8c20-59ed-b10a-a2d689e4ee0d', '6b7213e2-f576-5665-aa80-50923075da59', '9f7e776d-f1bc-5d3a-b8cc-43061e3afff0', 5);


INSERT INTO questions (id, question_text, question_type, options_json, points)
VALUES ('33be8343-c4ab-5715-b5bf-226eb2c2153f', 'Which statement best describes a list comprehension?', 'multiple_choice', '{"options":["A compact way to create a list from an iterable, optionally filtering items","A special kind of dictionary","A file-writing command","A replacement for every loop"]}', 10);
INSERT INTO question_answer_keys (id, question_id, correct_answer, explanation)
VALUES ('c6d1aef4-5541-54a8-83f1-bd6b541a4f77', '33be8343-c4ab-5715-b5bf-226eb2c2153f', '{"correct_index":0,"correct_value":"A compact way to create a list from an iterable, optionally filtering items"}', 'See chapter lessons for the underlying concept.');
INSERT INTO exam_questions (id, exam_id, question_id, order_index)
VALUES ('c6bf0b09-b57c-5bb3-a03b-f121e46f6cb5', '6b7213e2-f576-5665-aa80-50923075da59', '33be8343-c4ab-5715-b5bf-226eb2c2153f', 6);


INSERT INTO questions (id, question_text, question_type, options_json, points)
VALUES ('7ab8f16a-cfa0-5714-9fdd-2c9e7673b23b', 'Build a small persistent Python application using functions, a suitable data structure, file storage, input validation, and exception handling. The application must load existing data, allow the user to add or view records, show at least one calculated summary, and save the data before exit.', 'multiple_choice', '{"options":["Complete the coding task as described","Skip this task","Not applicable","Review the chapter first"]}', 10);
INSERT INTO question_answer_keys (id, question_id, correct_answer, explanation)
VALUES ('6aebcdb2-f431-50f9-8695-5d2be64bd808', '7ab8f16a-cfa0-5714-9fdd-2c9e7673b23b', '{"correct_index":0,"correct_value":"Complete the coding task as described"}', 'Complete the coding task as described in the question.');
INSERT INTO exam_questions (id, exam_id, question_id, order_index)
VALUES ('3ba4d962-086b-5c00-9623-6459bf1da381', '6b7213e2-f576-5665-aa80-50923075da59', '7ab8f16a-cfa0-5714-9fdd-2c9e7673b23b', 7);


SET FOREIGN_KEY_CHECKS = 1;
