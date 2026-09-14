<?php
/**
 * Student signup — simple path for small school use.
 * Required: full_name, username, password (+ confirm).
 * Grade/class are optional; if they match DB rows they are linked, otherwise class_id stays null.
 */
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../middleware/auth.php';

require_post_method();

$data = get_json_request();
if (empty($data) && !empty($_POST)) {
    $data = $_POST;
}

$full_name = trim($data['full_name'] ?? '');
$username = trim($data['username'] ?? '');
$password = $data['password'] ?? '';
$password_confirm = $data['password_confirm'] ?? $data['password'] ?? '';
$grade_input = trim($data['grade'] ?? $data['grade_id'] ?? '');
$class_input = trim($data['class_section'] ?? $data['class'] ?? $data['class_id'] ?? '');
$academic_level = trim($data['academic_level'] ?? $data['academic_group'] ?? '');

if ($full_name === '') {
    error_response('Full name is required', 400);
}
if (strlen($full_name) > 100) {
    error_response('Full name must not exceed 100 characters', 400);
}
if ($username === '') {
    error_response('Username is required', 400);
}
if (strlen($username) < 3) {
    error_response('Username must be at least 3 characters', 400);
}
if (strlen($username) > 50) {
    error_response('Username must not exceed 50 characters', 400);
}
if (!preg_match('/^[a-zA-Z0-9_.-]+$/', $username)) {
    error_response('Username can only contain letters, numbers, underscores, dots, and hyphens', 400);
}
if ($password === '') {
    error_response('Password is required', 400);
}
if (strlen($password) < 8) {
    error_response('Password must be at least 8 characters', 400);
}
if ($password !== $password_confirm) {
    error_response('Passwords do not match', 400);
}

try {
    $db = get_db_connection();

    // Username unique
    $stmt = $db->prepare('SELECT id FROM profiles WHERE LOWER(username) = LOWER(?) LIMIT 1');
    $stmt->execute([$username]);
    if ($stmt->fetch()) {
        error_response('Username is already taken. Please choose another.', 400);
    }

    // Optional: resolve grade + class if tables have matching rows (never block signup)
    $class_id = null;
    if ($grade_input !== '' || $class_input !== '') {
        try {
            $grade = null;
            if ($grade_input !== '') {
                $stmt = $db->prepare('SELECT id, name FROM grades WHERE id = ? OR LOWER(name) = LOWER(?) LIMIT 1');
                $stmt->execute([$grade_input, $grade_input]);
                $grade = $stmt->fetch(PDO::FETCH_ASSOC);
                if (!$grade) {
                    $alias = str_replace(['Sec ', 'Prep '], ['Secondary ', 'Preparatory '], $grade_input);
                    $stmt = $db->prepare('SELECT id, name FROM grades WHERE LOWER(name) = LOWER(?) OR name LIKE ? LIMIT 1');
                    $stmt->execute([$alias, '%' . $grade_input . '%']);
                    $grade = $stmt->fetch(PDO::FETCH_ASSOC);
                }
            }
            if ($grade && $class_input !== '') {
                $clean = trim(str_ireplace('section', '', $class_input));
                $stmt = $db->prepare("
                    SELECT id FROM classes
                    WHERE grade_id = ?
                      AND (
                        id = ? OR LOWER(name) = LOWER(?) OR LOWER(name) = LOWER(?)
                        OR name LIKE ? OR name LIKE ? OR name LIKE ?
                      )
                    LIMIT 1
                ");
                $stmt->execute([
                    $grade['id'],
                    $class_input,
                    $class_input,
                    $clean,
                    '%' . $clean . '%',
                    '% - ' . $clean,
                    '% ' . $clean
                ]);
                $row = $stmt->fetch(PDO::FETCH_ASSOC);
                if ($row) {
                    $class_id = $row['id'];
                }
            }
        } catch (Exception $ignore) {
            // Grade/class tables missing or mismatch — still allow signup
            $class_id = null;
        }
    }

    $id = generate_uuid_v4();
    $password_hash = password_hash($password, PASSWORD_DEFAULT);

    $db->beginTransaction();

    // is_active column may or may not exist on older imports — try with, fallback without
    try {
        $ins = $db->prepare('
            INSERT INTO profiles (id, username, password_hash, full_name, role, is_active, class_id)
            VALUES (?, ?, ?, ?, \'student\', 1, ?)
        ');
        $ins->execute([$id, $username, $password_hash, $full_name, $class_id]);
    } catch (PDOException $e) {
        // Fallback if is_active column missing
        $ins = $db->prepare('
            INSERT INTO profiles (id, username, password_hash, full_name, role, class_id)
            VALUES (?, ?, ?, ?, \'student\', ?)
        ');
        $ins->execute([$id, $username, $password_hash, $full_name, $class_id]);
    }

    // Optional gamification row
    try {
        $gam_id = generate_uuid_v4();
        $db->prepare('
            INSERT INTO student_gamification (id, user_id, total_xp, current_streak, longest_streak, last_activity_date)
            VALUES (?, ?, 0, 0, 0, NULL)
        ')->execute([$gam_id, $id]);
    } catch (Exception $ignore) {
        // table optional
    }

    $db->commit();

    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }
    session_regenerate_id(true);
    $_SESSION['user_id'] = $id;
    $_SESSION['username'] = $username;
    $_SESSION['full_name'] = $full_name;
    $_SESSION['role'] = 'student';
    $_SESSION['class_id'] = $class_id;
    $_SESSION['avatar_url'] = null;
    if (empty($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    }

    success_response([
        'message' => 'Registration successful',
        'user' => [
            'id' => $id,
            'username' => $username,
            'full_name' => $full_name,
            'role' => 'student',
            'class_id' => $class_id,
            'avatar_url' => null
        ],
        'csrf_token' => $_SESSION['csrf_token']
    ], 201);

} catch (PDOException $e) {
    if (isset($db) && $db->inTransaction()) {
        $db->rollBack();
    }
    error_log('Signup DB Error: ' . $e->getMessage());
    error_response('Database error during registration. Check that the profiles table exists and .env/config DB settings are correct.', 500);
} catch (Exception $e) {
    if (isset($db) && $db->inTransaction()) {
        $db->rollBack();
    }
    error_log('Signup Server Error: ' . $e->getMessage());
    $msg = $e->getMessage();
    if (stripos($msg, 'Database connection') !== false || stripos($msg, 'Database configuration') !== false) {
        error_response('Cannot connect to the database. Check DB settings in config/config.php.', 503);
    }
    error_response('Server error during registration. Please try again.', 500);
}
