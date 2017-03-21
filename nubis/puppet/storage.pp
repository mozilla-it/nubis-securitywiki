include nubis_storage

nubis::storage { $project_name:
  type  => 'efs',
  owner => 'apache',
  group => 'apache',
}

### puppet-nubis-storage

# Link to our mountpoint
file { '/var/www/html/images':
  ensure => 'link',
  target => "/data/${project_name}/images",
}

