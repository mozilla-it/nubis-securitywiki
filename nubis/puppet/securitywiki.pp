# Install mysql client libraries
include mysql::client

# Use Nubis's autoconfiguration hooks to trigger out config reloads

include nubis_configuration

nubis::configuration { $project_name:
  format => 'php',
  #This is a PHP app, doesn't really need reloading
  #reload => '/etc/init.d/apache2 reload',
}
