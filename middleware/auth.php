<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../includes/response.php';

// Configure secure session parameters before starting
if (session_status() === PHP_SESSION_NONE) {
    session_name(SESSION_NAME);
    ini_set('session.cookie_httponly', 1);
    ini_set('session.use_only_cookies', 1);
    ini_set('session.cookie_samesite', 'Lax');
    ini_set('session.gc_maxlifetime', SESSION_LIFETIME);
    session_start();
}

function is_logged_in() {
    return isset($_SESSION['user_id']);
}

function current_user() {
    if (!is_logged_in()) {
        return null;
    }
    
    return [
        'id' => $_SESSION['user_id'],
        'username' => $_SESSION['username'],
        'full_name' => $_SESSION['full_name'],
        'role' => $_SESSION['role'],
        'class_id' => $_SESSION['class_id'] ?? null,
        'avatar_url' => $_SESSION['avatar_url'] ?? null
    ];
}

function require_auth($roles = []) {
    if (!is_logged_in()) {
        error_response('Unauthorized', 401);
    }
    $user = current_user();
    if (!empty($roles) && !in_array($user['role'], $roles, true)) {
        error_response('Forbidden', 403);
    }
    return $user;
}
