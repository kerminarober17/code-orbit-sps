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

