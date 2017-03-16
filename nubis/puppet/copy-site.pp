# Copy index page to Apache web root

file { '/var/www/mediawiki/LocalSettings.php':
  ensure => file,
  owner  => root,
  group  => root,
  mode   => '0744',
  source => 'puppet:///nubis/files/LocalSettings.php',
}
