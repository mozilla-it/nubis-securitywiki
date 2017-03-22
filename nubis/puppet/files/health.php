<?php

require_once("/etc/nubis-config/securitywiki.php");

$conn = mysql_connect($DB_SERVER,$DB_USERNAME,$DB_PASSWORD);

if (!$conn) {
  http_response_code(500);
  echo "Can't connect to the database";
  exit;
}

$DB_NAME="foo";

$db   = mysql_select_db($DB_NAME);

if (!$db) {
  http_response_code(500);
  echo "Can't find the database $DB_NAME";
  exit;
}

$ping = mysql_ping();

if (!$ping) {
  http_response_code(500);
  echo "Database ping failed";
  exit;
}

echo "All Checks : OK";

?>
