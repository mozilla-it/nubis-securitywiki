# Define how Apache should be installed and configured

class { 'nubis_apache':
    # Changing the Apache mpm is necessary for the Apache PHP module
    mpm_module_type => 'prefork',
    check_url       => '/health.php',
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

    custom_fragment    => "
    Include /etc/apache2/conf-available/hostname.conf
        # Configure an SSO application at the APPURL provided when generating the metadata XML
    <Location />
        # This is the Mellon endpoint provided when generating the metadata XML.
        MellonEndpointPath /mellon

        # These are the generated private key, certificate, and metadata XML files.
        MellonSPPrivateKeyFile /etc/apache2/mozilla/mellon/securitywiki.allizom.org.key
        MellonSPCertFile /etc/apache2/mozilla/mellon/securitywiki.allizom.org.cert
        MellonSPMetadataFile /etc/apache2/mozilla/mellon/securitywiki.allizom.org.xml

        # This IdP Metadata XML binds this application to our SSO IdP (Okta).
        MellonIdPMetadataFile /etc/apache2/mozilla/mellon/securitywiki.allizom.org.idp-metadata.xml

        # Various other options that do not vary between sites.
        MellonSecureCookie On
        MellonSubjectConfirmationDataAddressCheck Off
    </Location>

    # This public, unrestricted endpoint is necessary for SAML communication with Mellon.
    <Location /mellon>
        # We do NOT specify MellonEnable 'none' here, because we need Mellon to process requests to this endpoint.

        # Disable authentication for this endpoint.
        AuthType none

        # Allow all requests to this endpoint.
        Order allow,deny
        Allow from all
        Satisfy any
    </Location>

    # Continue below for Location-specific Mellon 'authorization required' configs.
    <Location />
        # Mellon will intercept requests that do not provide a non-expired session cookie and redirect them momentarily to Okta.
        MellonEnable 'auth'
        AuthType Mellon
        # Ensure that we authenticated a valid user through Okta and Mellon. This provides a layer of defense against unplanned issues.
        require valid-user
    </Location>

    # Allow health-checks unauthenticated
    <Location /health.php>
        MellonEnable Off
        AuthType none
        Require all granted
    </Location>

    # Clustered without coordination
    FileETag None
    ",

    block              => ['scm'],
    setenvif           => [
      'X-Forwarded-Proto https HTTPS=on',
      'Remote_Addr 127\.0\.0\.1 internal',
      'Remote_Addr ^10\. internal',
    ],
    access_log_env_var => '!internal',
    access_log_format  => '%a %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"',
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
          '%{REQUEST_URI} !^/(redirect|index|opensearch_desc|api|load|thumb|health).php',
          '%{REQUEST_URI} !^/error/(40(1|3|4)|500).html',
          '%{REQUEST_URI} !^/favicon.ico',
          '%{REQUEST_URI} !^/robots.txt',
        ],
        rewrite_rule => ['^(.*)$ /index.php [L]'],
      }
    ]
}
