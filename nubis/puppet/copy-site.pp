# Copy index page to Apache web root

file { "/var/www/${project_name}/LocalSettings.php":
  ensure => file,
  owner  => root,
  group  => root,
  mode   => '0744',
  source => 'puppet:///nubis/files/LocalSettings.php',
}

file { "/var/www/${project_name}/health.php":
  ensure => file,
  owner  => root,
  group  => root,
  mode   => '0644',
  source => 'puppet:///nubis/files/health.php',
}

file { "/var/www/${project_name}/skins/gmo":
  ensure => 'link',
  target => "/var/www/${project_name}/extensions/gmo/skins/gmo",
  force  => true,
}
