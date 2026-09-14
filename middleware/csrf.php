<?php
require_once __DIR__ . '/auth.php';
require_once __DIR__ . '/../includes/response.php';

function get_csrf_token() {
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }
    if (empty($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    }
    return $_SESSION['csrf_token'];
}

function verify_csrf_token() {
    $method = $_SERVER['REQUEST_METHOD'] ?? 'GET';
    if (in_array($method, ['POST', 'PUT', 'PATCH', 'DELETE'])) {
        $token = $_SERVER['HTTP_X_CSRF_TOKEN'] ?? $_POST['csrf_token'] ?? '';
        
        // If JSON payload provided, also check csrf_token inside JSON
        if (empty($token)) {
            $input = json_decode(file_get_contents('php://input'), true);
            if (is_array($input) && !empty($input['csrf_token'])) {
                $token = $input['csrf_token'];
            }
        }

        $session_token = get_csrf_token();
        if (empty($token) || !hash_equals($session_token, $token)) {
            error_response('Invalid or missing CSRF token', 403);
        }
    }
}
