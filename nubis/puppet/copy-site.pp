# Copy index page to Apache web root

file { '/var/www/mediawiki/LocalSettings.php':
  ensure => file,
  owner  => root,
  group  => root,
  mode   => '0744',
  source => 'puppet:///nubis/files/LocalSettings.php',
}

file { '/var/www/mediawiki/skins/cavendish':
  ensure => 'link',
  target => "/var/www/mediawiki/extensions/gmo/skins/Cavendish",
  force => true,
}

file { '/var/www/mediawiki/skins/gmo':
  ensure => 'link',
  target => "/var/www/mediawiki/extensions/gmo/skins/gmo",
  force => true,
}
