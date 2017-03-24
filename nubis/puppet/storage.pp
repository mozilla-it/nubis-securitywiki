include nubis_storage

nubis::storage { $project_name:
  type  => 'efs',
  owner => 'www-data',
  group => 'www-data',
}

### puppet-nubis-storage

# Link to our mountpoint
file { '/var/www/mediawiki/images':
  ensure => 'link',
  force  => true,
  target => "/data/${project_name}/images",
  force => true,
}
