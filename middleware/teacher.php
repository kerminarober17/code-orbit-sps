<?php
require_once __DIR__ . '/auth.php';

function require_teacher() {
    $user = require_auth();
    if ($user['role'] !== 'teacher') {
        error_response('Forbidden. Teacher access required.', 403);
    }
    return $user;
}
