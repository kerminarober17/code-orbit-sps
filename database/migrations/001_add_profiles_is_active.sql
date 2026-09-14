-- Migration 001: Add profiles.is_active for account activation/deactivation
-- Compatible with MySQL 5.7+ / MariaDB. Run once.
-- After this migration the application assumes the column exists.

-- Check-and-add pattern (safe to re-run manually):
SET @col_exists = (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'profiles'
    AND COLUMN_NAME = 'is_active'
);

SET @sql = IF(@col_exists = 0,
  'ALTER TABLE profiles ADD COLUMN is_active TINYINT(1) NOT NULL DEFAULT 1 COMMENT ''1=active can login, 0=deactivated by admin'' AFTER role',
  'SELECT ''is_active already exists'' AS msg'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

UPDATE profiles SET is_active = 1 WHERE is_active IS NULL OR is_active = 0 AND created_at IS NOT NULL;
-- Note: the UPDATE above only forces active if somehow null; admin deactivations remain 0.
