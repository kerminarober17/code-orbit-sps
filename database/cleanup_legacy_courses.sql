-- =========================================================================
-- SPS Code Orbit: One-Time Legacy Courses Cleanup Script
-- Safely removes all legacy courses and their dependent data.
-- PRESERVES:
--   1. 'course-programming-foundations' (Programming Foundations — Start Here)
--   2. 'course-python-foundations' (Python Foundations)
--   3. All user accounts, profiles, passwords, roles (students, teachers, admins)
--   4. All academic groups, classes, grades, and system settings
-- =========================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- 1. Identify legacy course IDs: All courses EXCEPT the 2 production courses
-- Production courses to keep:
--   - 'course-programming-foundations'
--   - 'course-python-foundations'

-- 2. Delete Exam Attempts Archive for legacy exams
DELETE FROM exam_attempts_archive 
WHERE exam_id IN (
    SELECT e.id FROM exams e 
    JOIN chapters ch ON e.chapter_id = ch.id 
    WHERE ch.course_id NOT IN ('course-programming-foundations', 'course-python-foundations')
);

-- 3. Delete Exam Attempts for legacy exams
DELETE FROM exam_attempts 
WHERE exam_id IN (
    SELECT e.id FROM exams e 
    JOIN chapters ch ON e.chapter_id = ch.id 
    WHERE ch.course_id NOT IN ('course-programming-foundations', 'course-python-foundations')
);

-- 4. Delete Answers for legacy questions
DELETE FROM answers 
WHERE question_id IN (
    SELECT eq.question_id FROM exam_questions eq
    JOIN exams e ON eq.exam_id = e.id
    JOIN chapters ch ON e.chapter_id = ch.id
    WHERE ch.course_id NOT IN ('course-programming-foundations', 'course-python-foundations')
);

-- 5. Delete Question Answer Keys for legacy questions
DELETE FROM question_answer_keys 
WHERE question_id IN (
    SELECT eq.question_id FROM exam_questions eq
    JOIN exams e ON eq.exam_id = e.id
    JOIN chapters ch ON e.chapter_id = ch.id
    WHERE ch.course_id NOT IN ('course-programming-foundations', 'course-python-foundations')
);

-- 6. Delete Questions for legacy exams
DELETE FROM questions 
WHERE id IN (
    SELECT eq.question_id FROM exam_questions eq
    JOIN exams e ON eq.exam_id = e.id
    JOIN chapters ch ON e.chapter_id = ch.id
    WHERE ch.course_id NOT IN ('course-programming-foundations', 'course-python-foundations')
);

-- 7. Delete Exam Questions for legacy exams
DELETE FROM exam_questions 
WHERE exam_id IN (
    SELECT e.id FROM exams e 
    JOIN chapters ch ON e.chapter_id = ch.id 
    WHERE ch.course_id NOT IN ('course-programming-foundations', 'course-python-foundations')
);

-- 8. Delete Exams for legacy chapters
DELETE FROM exams 
WHERE chapter_id IN (
    SELECT ch.id FROM chapters ch 
    WHERE ch.course_id NOT IN ('course-programming-foundations', 'course-python-foundations')
);

-- 9. Delete Lesson Blocks for legacy lessons
DELETE FROM lesson_blocks 
WHERE lesson_id IN (
    SELECT l.id FROM lessons l 
    JOIN chapters ch ON l.chapter_id = ch.id 
    WHERE ch.course_id NOT IN ('course-programming-foundations', 'course-python-foundations')
);

-- 10. Delete Lesson Progress for legacy lessons
DELETE FROM lesson_progress 
WHERE lesson_id IN (
    SELECT l.id FROM lessons l 
    JOIN chapters ch ON l.chapter_id = ch.id 
    WHERE ch.course_id NOT IN ('course-programming-foundations', 'course-python-foundations')
);

-- 11. Delete Chapter Progress for legacy chapters
DELETE FROM chapter_progress 
WHERE chapter_id IN (
    SELECT ch.id FROM chapters ch 
    WHERE ch.course_id NOT IN ('course-programming-foundations', 'course-python-foundations')
);

-- 12. Delete Course Progress for legacy courses
DELETE FROM course_progress 
WHERE course_id NOT IN ('course-programming-foundations', 'course-python-foundations');

-- 13. Delete User Progress for legacy courses
DELETE FROM user_progress 
WHERE course_id NOT IN ('course-programming-foundations', 'course-python-foundations');

-- 14. Delete Course Class Assignments for legacy courses
DELETE FROM course_class_assignments 
WHERE course_id NOT IN ('course-programming-foundations', 'course-python-foundations');

-- 15. Delete Course Enrollments for legacy courses
DELETE FROM course_enrollments 
WHERE course_id NOT IN ('course-programming-foundations', 'course-python-foundations');

-- 16. Delete Lessons for legacy chapters
DELETE FROM lessons 
WHERE chapter_id IN (
    SELECT ch.id FROM chapters ch 
    WHERE ch.course_id NOT IN ('course-programming-foundations', 'course-python-foundations')
);

-- 17. Delete Chapters for legacy courses
DELETE FROM chapters 
WHERE course_id NOT IN ('course-programming-foundations', 'course-python-foundations');

-- 18. Delete Legacy Courses
DELETE FROM courses 
WHERE id NOT IN ('course-programming-foundations', 'course-python-foundations');

SET FOREIGN_KEY_CHECKS = 1;

-- Verification query: Must return exactly 2 rows
SELECT id, slug, title, is_published FROM courses ORDER BY id;
