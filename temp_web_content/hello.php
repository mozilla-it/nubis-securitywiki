<?php
$nubisConfig = "/etc/nubis-config/securitywiki.php";

if(file_exists($nubisConfig)){
  require_once($nubisConfig);
}

echo "Hello, Nubis world!<br>\n";

echo "Database is $DB_NAME<br>\n";

echo "Server is $DB_SERVER<br>\n";

echo "Username is $DB_USERNAME<br>\n";

echo "Database password is a secret, but check \$DB_PASSWORD<br>\n";

?>
