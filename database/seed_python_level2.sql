-- DEPRECATED structure-only scaffold. Use database/production_rebuild.sql.
-- Python Level 2 course seed
INSERT INTO courses (id, academic_group_id, title, slug, description, image_url, accent_color, is_published, created_at, updated_at)
SELECT 'course-python-level-2', id, 'Python Level 2: Code Orbit', 'python-level-2',
'Continue from Python Level 1. Master text, collections, comprehensions, dictionaries, scope, files, modules, errors, and OOP.',
'/assets/courses/algo.png', '#8B5CF6', 1, NOW(), NOW() FROM academic_groups WHERE name LIKE '%Prep%' LIMIT 1
ON DUPLICATE KEY UPDATE title=VALUES(title), description=VALUES(description), is_published=1, updated_at=NOW();

INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at)
VALUES ('chap-pyl2-01', 'course-python-level-2', 'chapter-1', 1, 'Text Power-Up', 'Level 2 Chapter 1', '🚀', 100, NOW(), NOW())
ON DUPLICATE KEY UPDATE title=VALUES(title), updated_at=NOW();

INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at)
VALUES ('chap-pyl2-02', 'course-python-level-2', 'chapter-2', 2, 'Smarter Collections', 'Level 2 Chapter 2', '🚀', 100, NOW(), NOW())
ON DUPLICATE KEY UPDATE title=VALUES(title), updated_at=NOW();

INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at)
VALUES ('chap-pyl2-03', 'course-python-level-2', 'chapter-3', 3, 'List Comprehensions', 'Level 2 Chapter 3', '🚀', 100, NOW(), NOW())
ON DUPLICATE KEY UPDATE title=VALUES(title), updated_at=NOW();

INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at)
VALUES ('chap-pyl2-04', 'course-python-level-2', 'chapter-4', 4, 'Dictionaries', 'Level 2 Chapter 4', '🚀', 100, NOW(), NOW())
ON DUPLICATE KEY UPDATE title=VALUES(title), updated_at=NOW();

INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at)
VALUES ('chap-pyl2-05', 'course-python-level-2', 'chapter-5', 5, 'Scope & Better Functions', 'Level 2 Chapter 5', '🚀', 100, NOW(), NOW())
ON DUPLICATE KEY UPDATE title=VALUES(title), updated_at=NOW();

INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at)
VALUES ('chap-pyl2-06', 'course-python-level-2', 'chapter-6', 6, 'Files & Persistence', 'Level 2 Chapter 6', '🚀', 100, NOW(), NOW())
ON DUPLICATE KEY UPDATE title=VALUES(title), updated_at=NOW();

INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at)
VALUES ('chap-pyl2-07', 'course-python-level-2', 'chapter-7', 7, 'Modules & the Standard Library', 'Level 2 Chapter 7', '🚀', 100, NOW(), NOW())
ON DUPLICATE KEY UPDATE title=VALUES(title), updated_at=NOW();

INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at)
VALUES ('chap-pyl2-08', 'course-python-level-2', 'chapter-8', 8, 'Errors & Defensive Programs', 'Level 2 Chapter 8', '🚀', 100, NOW(), NOW())
ON DUPLICATE KEY UPDATE title=VALUES(title), updated_at=NOW();

INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at)
VALUES ('chap-pyl2-09', 'course-python-level-2', 'chapter-9', 9, 'First Steps into Object-Oriented Programming', 'Level 2 Chapter 9', '🚀', 100, NOW(), NOW())
ON DUPLICATE KEY UPDATE title=VALUES(title), updated_at=NOW();

INSERT INTO chapters (id, course_id, slug, chapter_number, title, description, icon_symbol, xp_reward, created_at, updated_at)
VALUES ('chap-pyl2-10', 'course-python-level-2', 'chapter-10', 10, 'Python Project Lab', 'Level 2 Chapter 10', '🚀', 100, NOW(), NOW())
ON DUPLICATE KEY UPDATE title=VALUES(title), updated_at=NOW();
