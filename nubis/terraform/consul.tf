# Discover Consul settings
module "consul" {
  source       = "github.com/nubisproject/nubis-terraform//consul?ref=v2.0.4"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
}

# Configure our Consul provider, module can't do it for us
provider "consul" {
  address    = "${module.consul.address}"
  scheme     = "${module.consul.scheme}"
  datacenter = "${module.consul.datacenter}"
}

# Publish our outputs into Consul for our application to consume
resource "consul_keys" "config" {
  key {
    name   = "environment"
    path   = "${module.consul.config_prefix}/ENVIRONMENT"
    value  = "${var.environment}"
    delete = true
  }

  key {
    name   = "db_name"
    path   = "${module.consul.config_prefix}/DB_NAME"
    value  = "${module.database.name}"
    delete = true
  }

  key {
    name   = "db_server"
    path   = "${module.consul.config_prefix}/DB_SERVER"
    value  = "${module.database.address}"
    delete = true
  }

  key {
    name   = "db_username"
    path   = "${module.consul.config_prefix}/DB_USERNAME"
    value  = "${module.database.username}"
    delete = true
  }

  key {
    name   = "db_password"
    path   = "${module.consul.config_prefix}/DB_PASSWORD"
    value  = "${module.database.password}"
    delete = true
  }

  key {
    name   = "site_url"
    path   = "${module.consul.config_prefix}/SITE_URL"
    value  = "https://${module.dns.fqdn}"
    delete = true
  }

  key {
    path   = "${module.consul.config_prefix}/Bucket/Backup/Name"
    value  = "${module.backup.name}"
    delete = true
  }

  key {
    path   = "${module.consul.config_prefix}/Bucket/Backup/Region"
    value  = "${var.region}"
    delete = true
  }

  # For mod_auth_openidc
  key {
    name   = "openid_server_passphrase"
    path   = "${module.consul.config_prefix}/OpenID/Server/Passphrase"
    value  = "${random_id.openid_server_passphrase.b64_url}"
    delete = true
  }
  key {
    name   = "openid_server_memcached"
    path   = "${module.consul.config_prefix}/OpenID/Server/Memcached"
    value  = "${module.cache.endpoint}"
    delete = true
  }
}

resource "random_id" "openid_server_passphrase" {
  byte_length = 16
}
