<?php
require_once __DIR__ . '/../../includes/helpers.php';
require_once __DIR__ . '/../../includes/response.php';
require_once __DIR__ . '/../../middleware/auth.php';
require_once __DIR__ . '/../../middleware/csrf.php';

require_post_method();
verify_csrf_token();

// Unconditionally destroy session and clear session cookies
$_SESSION = [];
if (ini_get("session.use_cookies")) {
    $params = session_get_cookie_params();
    setcookie(session_name(), '', time() - 42000,
        $params["path"] ?: '/', $params["domain"] ?: '',
        $params["secure"] ?: false, $params["httponly"] ?: true
    );
    // Also explicitly expire custom session name cookie at root path
    setcookie('sps_session', '', time() - 42000, '/');
}

if (session_status() === PHP_SESSION_ACTIVE) {
    session_destroy();
}

success_response(['message' => 'Logged out successfully']);


