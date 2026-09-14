<?php
require_once __DIR__ . '/auth.php';

function require_student() {
    $user = require_auth();
    if ($user['role'] !== 'student') {
        error_response('Forbidden. Student access required.', 403);
    }
    return $user;
}
