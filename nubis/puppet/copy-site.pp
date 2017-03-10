# Copy index page to Apache web root

file { '/var/www/html/index.htm':
	ensure => file,
	owner	 => root,
	group  => root,
	mode   => '0755',
	source => 'puppet:///nubis/files/index.htm',
}

file { '/var/www/html/LocalSettings.php':
	ensure => file,
	owner	 => root,
	group  => root,
	mode   => '0744',
	source => 'puppet:///nubis/files/LocalSettings.php',
}
