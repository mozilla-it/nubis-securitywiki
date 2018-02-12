# Install mysql client libraries
include mysql::client

package { 'php-mysql':
  ensure => 'latest'
}

package { 'php-memcache':
  ensure => 'latest'
}

package { 'composer':
  ensure => 'latest',
}

# Use Nubis's autoconfiguration hooks to trigger out config reloads

include nubis_configuration

nubis::configuration { $project_name:
  format => 'php',
}

file { [ '/etc/php', '/etc/php/7.0', '/etc/php/7.0/apache2', '/etc/php/7.0/apache2/conf.d' ]:
  ensure => directory,
  owner  => root,
  group  => root,
  mode   => '0744',
}

file { "/etc/php/7.0/apache2/conf.d/30-$project_name.ini":
  ensure => file,
  owner  => root,
  group  => root,
  mode   => '0744',
  source => 'puppet:///nubis/files/php.ini',
}

file { "/data/$project_name/php_sessions":
  ensure => directory,
  owner  => www-data,
  group  => www-data,
  mode   => '0733',
}
