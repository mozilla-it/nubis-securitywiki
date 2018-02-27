# Securitywiki Nubis deployment repository

This is the deployment repository for
[securitywiki.mozilla.org](https://securitywiki.mozilla.org), a MediaWiki site

## Components

Defined in [nubis/terraform/main.tf](nubis/terraform)

### Webservers

Defined in [nubis/puppet/apache.pp](nubis/puppet)

The produced image is that of a simple Ubuntu Apache webserver running PHP

### Load Balancer

Simple ELB

### SSO

This entire application is protected behind mod_auth_openidc

### Database

Main application state is persisted in an RDS/MySQL database

Administrative access to it can be gained thru the db-admin service.

### Storage

EFS/NFS is used to store uploaded assets, mounted under
/data on each of the webserver nodes

### Buckets

An S3 bucket is used to store periodic backups of the [Storage](#Storage)

### Cache

Elasticache/Memcache is used to provide persistency for MediaWiki's cache.

## Configuration

The application's configuration file is
[LocalSettings.php](nubis/puppet/files/LocalSettings.php)
and is not managed, it simply sources nubis_configuration
from */etc/nubis-config/${project_name}.php*

### Consul Keys

This application's Consul keys, living under
*${project_name}-${environment}/${environment}/config/*
and defined in Defined in [nubis/terraform/consul.tf](nubis/terraform)

#### ENVIRONMENT

The current deployment's environment

#### SITE_URL

The URL for the ELB of this deployment

#### Bucket/Backup/Name

Name of the S3 bucket used for backups

#### Bucket/Backup/Region

Region of the S3 bucket used for backups

#### Cache/Endpoint

DNS endpoint of Elasticache/memcache

#### Cache/Port

TCP port of Elasticache/memcache

#### Database/Name

The name of the RDS/MySQL Database

#### Database/Password

The password to the RDS/MySQL Database

#### Database/User

The username to the RDS/MySQL Database

#### Database/Server

The hostname of the RDS/MySQL Database

#### OpenID/Server/Memcached

Hostname:Port of Elasticache/memcache

#### OpenID/Server/Passphrase

*Generated* OpenID passphrase for session encryption

#### OpenID/Client/Domain

*Operator Supplied* Auth0 Domain for this application, typically 'mozilla'

#### OpenID/Client/ID

*Operator Supplied* Auth0 Client ID for this application

#### OpenID/Client/Secret

*Operator Supplied* Auth0 Client Secret for this application 'mozilla'

#### OpenID/Client/Site

*Operator Supplied* Auth0 Site URL for this application

#### storage/${project_name}/fsid

[Storage](#Storage) Filesystem ID

## Cron Jobs

Daily backup job copies data from [Storage](#Storage) to [Buckets](#Buckets)

## Logs

No application specific logs
