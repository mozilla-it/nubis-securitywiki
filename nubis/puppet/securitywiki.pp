# Install mysql client libraries
include mysql::client

package { "php5-mysql":
  ensure => '5.5.9+dfsg-1ubuntu4.21'
}

package { 'php5-xcache':
  ensure => '3.1.0-2'
}

# Use Nubis's autoconfiguration hooks to trigger out config reloads

include nubis_configuration

nubis::configuration { $project_name:
  format => 'php',
  #This is a PHP app, doesn't really need reloading
  #reload => '/etc/init.d/apache2 reload',
}
