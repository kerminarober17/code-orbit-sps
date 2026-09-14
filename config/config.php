<?php
/**
 * SPS Code Orbit — configuration
 *
 * SIMPLE SETUP (recommended for InfinityFree / small school):
 *   Edit the DB_* values in the "DIRECT SETTINGS" section below.
 *
 * Optional: use a .env file instead; non-empty .env values override the directs below.
 */

// ---------------------------------------------------------------------------
// DIRECT SETTINGS — put your InfinityFree MySQL details here
// ---------------------------------------------------------------------------
$DB_HOST_DEFAULT     = 'sqlXXX.infinityfree.com';  // from hosting panel (NOT always localhost)
$DB_PORT_DEFAULT     = '3306';
$DB_NAME_DEFAULT     = 'if0_XXXXXX_dbname';        // exact database name from panel
$DB_USER_DEFAULT     = 'if0_XXXXXX';              // exact username from panel
$DB_PASSWORD_DEFAULT = 'your_password_here';       // exact password from panel
$DB_CHARSET_DEFAULT  = 'utf8mb4';

$APP_NAME_DEFAULT    = 'SPS Code Orbit';
$APP_ENV_DEFAULT     = 'production';               // production | development
$SESSION_NAME_DEFAULT    = 'sps_session';
$SESSION_LIFETIME_DEFAULT = 86400;

// ---------------------------------------------------------------------------
// Optional .env loader (does not override if value is empty)
// ---------------------------------------------------------------------------
$envFile = __DIR__ . '/../.env';
if (file_exists($envFile)) {
    $lines = file($envFile, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    foreach ($lines as $line) {
        $line = trim($line);
        if ($line === '' || $line[0] === '#' || strpos($line, '=') === false) {
            continue;
        }
        list($name, $value) = explode('=', $line, 2);
        $name = trim($name);
        $value = trim($value);
        if (preg_match('/^"(.*)"$/', $value, $m) || preg_match("/^'(.*)'$/", $value, $m)) {
            $value = $m[1];
        }
        if ($value !== '') {
            putenv("$name=$value");
            $_ENV[$name] = $value;
            $_SERVER[$name] = $value;
        }
    }
}

function sps_env($key, $default) {
    $v = getenv($key);
    if ($v === false || $v === '') {
        return $default;
    }
    return $v;
}

define('DB_HOST', sps_env('DB_HOST', $DB_HOST_DEFAULT));
define('DB_PORT', sps_env('DB_PORT', $DB_PORT_DEFAULT));
define('DB_NAME', sps_env('DB_NAME', $DB_NAME_DEFAULT));
define('DB_USER', sps_env('DB_USER', $DB_USER_DEFAULT));
define('DB_PASSWORD', sps_env('DB_PASSWORD', $DB_PASSWORD_DEFAULT));
define('DB_CHARSET', sps_env('DB_CHARSET', $DB_CHARSET_DEFAULT));

define('APP_NAME', sps_env('APP_NAME', $APP_NAME_DEFAULT));
define('APP_ENV', sps_env('APP_ENV', $APP_ENV_DEFAULT));
define('SESSION_NAME', sps_env('SESSION_NAME', $SESSION_NAME_DEFAULT));
define('SESSION_LIFETIME', (int) sps_env('SESSION_LIFETIME', (string)$SESSION_LIFETIME_DEFAULT));
