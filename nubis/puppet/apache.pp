# Define how Apache should be installed and configured

class { 'nubis_apache':
    # Changing the Apache mpm is necessary for the Apache PHP module
    mpm_module_type => 'prefork',
}

class { 'apache::mod::auth_mellon': }
class { 'apache::mod::php': }

apache::vhost { $project_name:
    serveradmin        => 'webops@mozilla.com',
    port               => 80,
    default_vhost      => true,
    docroot            => '/var/www/mediawiki',
    directoryindex     => 'index.php',
    docroot_owner      => 'root',
    docroot_group      => 'root',
    directories        => [
      {
        path                       => '/',
        provider                   => 'location',
        mellon_enable              => 'auth',
        mellon_sp_private_key_file => '/etc/apache2/mozilla/mellon/securitywiki.allizom.org.key',
        mellon_sp_cert_file        => '/etc/apache2/mozilla/mellon/securitywiki.allizom.org.cert',
        mellon_sp_metadata_file    => '/etc/apache2/mozilla/mellon/securitywiki.allizom.org.xml',
        mellon_idp_metadata_file   => '/etc/apache2/mozilla/mellon/securitywiki.allizom.org.idp-metadata.xml',
        mellon_endpoint_path       => '/mellon',
        auth_require               => 'valid-user'
      },
      {
        path                       => '/mellon',
        provider                   => 'location',
        mellon_enable              => 'info',
        auth_type                  => 'none'
      },
      {
        path                       => '/status',
        provider                   => 'location',
        mellon_enable              => 'off',
        auth_type                  => 'none',
        auth_require               => 'all granted'
      }
    ],
    block              => ['scm'],
    setenvif           => [
      'X_FORWARDED_PROTO https HTTPS=on',
      'Remote_Addr 127\.0\.0\.1 internal',
      'Remote_Addr ^10\. internal',
    ],
    access_log_env_var => '!internal',
    access_log_format  => '%a %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"',
    custom_fragment    => "
    # Clustered without coordination
    FileETag None
    ",
    headers            => [
      "set X-Nubis-Version ${project_version}",
      "set X-Nubis-Project ${project_name}",
      "set X-Nubis-Build   ${packer_build_name}",
    ],
    rewrites           => [
      {
        comment      => 'HTTPS redirect',
        rewrite_cond => ['%{HTTP:X-Forwarded-Proto} =http'],
        rewrite_rule => ['. https://%{HTTP:Host}%{REQUEST_URI} [L,R=permanent]'],
      },
      {
        comment      => 'Don\'t rewrite requests for files in MediaWiki subdirectories, MediaWiki PHP files, HTTP error documents, favicon.ico, or robots.txt',
        rewrite_cond => [
          '%{REQUEST_URI} !^/(stylesheets|images|skins|documents)/',
          '%{REQUEST_URI} !^/(redirect|index|opensearch_desc|api|load|thumb).php',
          '%{REQUEST_URI} !^/error/(40(1|3|4)|500).html',
          '%{REQUEST_URI} !^/favicon.ico',
          '%{REQUEST_URI} !^/robots.txt',
          '%{REQUEST_URI} !^/mellon/',
        ],
        rewrite_rule => ['^(.*)$ /index.php [L]'],
      }
    ]
}
