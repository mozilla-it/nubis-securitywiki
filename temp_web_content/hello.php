<?php
$nubisConfig = "/etc/nubis-config/securitywiki.php";

if(file_exists($nubisConfig)){
  require_once($nubisConfig);
}

echo "Hello, Nubis world!\n";

echo "Database is $DB_NAME\n";

echo "Server is $DB_SERVER\n";

echo "Username is $DB_USERNAME\n";

echo "Database password is a secret, but check \$DB_PASSWORD\n"

?>
