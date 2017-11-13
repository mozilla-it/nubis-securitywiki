module "worker" {
  source            = "github.com/nubisproject/nubis-terraform//worker?ref=v2.0.1"
  region            = "${var.region}"
  environment       = "${var.environment}"
  account           = "${var.account}"
  service_name      = "${var.service_name}"
  purpose           = "webserver"
  ami               = "${var.ami}"
  elb               = "${module.load_balancer.name}"
  nubis_sudo_groups = "team_webops,nubis_global_admins"
}

module "load_balancer" {
  source              = "github.com/nubisproject/nubis-terraform//load_balancer?ref=v2.0.1"
  region              = "${var.region}"
  environment         = "${var.environment}"
  account             = "${var.account}"
  service_name        = "${var.service_name}"
  health_check_target = "HTTP:80/health.php"
  ssl_cert_name_prefix = "securitywiki"
}

module "database" {
  source                 = "github.com/nubisproject/nubis-terraform//database?ref=v2.0.1"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  account                = "${var.account}"
  service_name           = "${var.service_name}"
  client_security_groups = "${module.worker.security_group}"
}

module "dns" {
  source       = "github.com/nubisproject/nubis-terraform//dns?ref=v2.0.1"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
  target       = "${module.load_balancer.address}"
}

module "storage" {
  source                 = "github.com/nubisproject/nubis-terraform//storage?ref=v2.0.1"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  account                = "${var.account}"
  service_name           = "${var.service_name}"
  storage_name           = "${var.service_name}"
  client_security_groups = "${module.worker.security_group}"
}

module "backup" {
  source       = "github.com/nubisproject/nubis-terraform//bucket?ref=v2.0.1"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
  purpose      = "backup"
  role         = "${module.worker.role}"
}

module "cache" {
  source                 = "github.com/nubisproject/nubis-terraform//cache?ref=v2.0.1"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  account                = "${var.account}"
  service_name           = "${var.service_name}"
  client_security_groups = "${module.worker.security_group}"
}
