<?php

require_once("/etc/nubis-config/securitywiki.php");

$mysqli = new mysqli($DB_SERVER, $DB_USERNAME, $DB_PASSWORD, $DB_NAME);
if (!$mysqli) {
    http_response_code(500);
    echo "Can't connect to the database";
    exit;
}

/* check if server is alive */
if (!$mysqli->ping()) {
    http_response_code(500);
    echo "Database ping failed";
    exit;
}

echo "All Checks : OK";

?>
