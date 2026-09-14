<?php
require_once __DIR__ . '/auth.php';

function require_admin() {
    $user = require_auth();
    if ($user['role'] !== 'admin') {
        error_response('Forbidden. Admin access required.', 403);
    }
    return $user;
}
