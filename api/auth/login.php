<?php
require_once __DIR__ . '/../../config/database.php';
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../middleware/auth.php';

require_post_method();

// Ensure session is active
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// Support both JSON payloads and form-encoded POST
$data = get_json_request();
if (empty($data) && !empty($_POST)) {
    $data = $_POST;
}

$username = trim($data['username'] ?? $_POST['username'] ?? '');
$password = $data['password'] ?? $_POST['password'] ?? '';

if (empty($username) || empty($password)) {
    error_response('Username and password are required', 400);
}

if (strlen($username) > 100 || strlen($password) > 128) {
    error_response('Invalid credentials length', 400);
}

try {
    $db = get_db_connection();
    $stmt = $db->prepare("
        SELECT id, username, password_hash, full_name, role, class_id, avatar_url, is_active
        FROM profiles 
        WHERE LOWER(username) = LOWER(?)
    ");
    $stmt->execute([$username]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$user || !password_verify($password, $user['password_hash'])) {
        error_response('Invalid username or password', 401);
    }

    // Enforce account activation (is_active must be present after migration 001)
    if (isset($user['is_active']) && (int)$user['is_active'] !== 1) {
        error_response('Account is deactivated. Please contact an administrator.', 403);
    }

    // Regenerate session ID to prevent session fixation attacks
    session_regenerate_id(true);

    // Store basic user info in session
    $_SESSION['user_id'] = $user['id'];
    $_SESSION['username'] = $user['username'];
    $_SESSION['full_name'] = $user['full_name'];
    $_SESSION['role'] = $user['role'];
    $_SESSION['class_id'] = $user['class_id'];
    $_SESSION['avatar_url'] = $user['avatar_url'];
    if (empty($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    }

    success_response([
        'user' => [
            'id' => $user['id'],
            'username' => $user['username'],
            'full_name' => $user['full_name'],
            'role' => $user['role'],
            'class_id' => $user['class_id'],
            'avatar_url' => $user['avatar_url']
        ],
        'csrf_token' => $_SESSION['csrf_token']
    ]);

} catch (Exception $e) {
    error_log('Login Server Error: ' . $e->getMessage());
    $msg = $e->getMessage();
    if (stripos($msg, 'Database connection') !== false || stripos($msg, 'Database configuration') !== false) {
        error_response('Cannot connect to the database. Check .env and /api/system/db_ping.php', 503);
    }
    error_response('Authentication failed. Please try again.', 500);
}

