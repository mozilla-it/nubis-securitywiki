# Install mysql client libraries
include mysql::client

package { "php5-mysql":
  ensure => '5.5.9+dfsg-1ubuntu4.22'
}

package { 'php5-xcache':
  ensure => '3.1.0-2'
}

package { 'php5-memcache':
  ensure => 'latest'
}

# Use Nubis's autoconfiguration hooks to trigger out config reloads

include nubis_configuration

nubis::configuration { $project_name:
  format => 'php',
  #This is a PHP app, doesn't really need reloading
  #reload => '/etc/init.d/apache2 reload',
}

file { [ '/etc/php5', '/etc/php5/apache2', '/etc/php5/apache2/conf.d' ]:
  ensure => directory,
  owner  => root,
  group  => root,
  mode   => '0744',
}

file { '/etc/php5/apache2/conf.d/30-securitywiki.ini':
  ensure => file,
  owner  => root,
  group  => root,
  mode   => '0744',
  source => 'puppet:///nubis/files/php/30-securitywiki.ini',
}

file { '/etc/apache2/mellon':
  ensure => directory,
  owner  => root,
  group  => root,
  mode   => '0744',
}

file { '/data/securitywiki/php_sessions':
  ensure => directory,
  owner  => www-data,
  group  => www-data,
  mode   => '0733',
}
