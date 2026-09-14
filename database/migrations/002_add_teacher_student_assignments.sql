-- Migration 002: Explicit teacher → individual student assignments
SET @exists = (
  SELECT COUNT(*) FROM information_schema.TABLES
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'teacher_student_assignments'
);
SET @sql = IF(@exists = 0,
  'CREATE TABLE teacher_student_assignments (
    id CHAR(36) PRIMARY KEY,
    teacher_id CHAR(36) NOT NULL,
    student_id CHAR(36) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (teacher_id) REFERENCES profiles(id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES profiles(id) ON DELETE CASCADE,
    UNIQUE KEY uk_teacher_student (teacher_id, student_id)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4',
  'SELECT ''teacher_student_assignments already exists'' AS msg'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
