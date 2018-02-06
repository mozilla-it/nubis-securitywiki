include nubis_storage

nubis::storage { $project_name:
  type  => 'efs',
  owner => 'www-data',
  group => 'www-data',
}

### puppet-nubis-storage

# Link to our mountpoint
file { "/var/www/${project_name}/images":
  ensure => 'link',
  force  => true,
  target => "/data/${project_name}/images",
}

# For backups to S3
package { 'awscli':
  ensure => 'latest'
}
