provider "aws" {
  region = "${var.region}"
}

module "worker" {
  source            = "github.com/nubisproject/nubis-terraform//worker?ref=v2.3.0"
  region            = "${var.region}"
  environment       = "${var.environment}"
  account           = "${var.account}"
  service_name      = "${var.service_name}"
  purpose           = "webserver"
  instance_type     = "${var.environment == "prod" ? "m5.large": "t3.small"}"
  ami               = "${var.ami}"
  elb               = "${module.load_balancer.name}"
  nubis_sudo_groups = "team_webops,nubis_global_admins"

  # CPU utilisation based autoscaling (with good defaults)
  scale_load_defaults = true
  min_instances       = 2
}

module "load_balancer" {
  source               = "github.com/nubisproject/nubis-terraform//load_balancer?ref=v2.3.0"
  region               = "${var.region}"
  environment          = "${var.environment}"
  account              = "${var.account}"
  service_name         = "${var.service_name}"
  health_check_target  = "HTTP:80/health.php"
  ssl_cert_name_prefix = "${var.service_name}"
}

module "database" {
  source                 = "github.com/nubisproject/nubis-terraform//database?ref=v2.3.0"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  account                = "${var.account}"
  service_name           = "${var.service_name}"
  client_security_groups = "${module.worker.security_group}"
}

module "dns" {
  source       = "github.com/nubisproject/nubis-terraform//dns?ref=v2.3.0"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
  target       = "${module.load_balancer.address}"
}

module "storage" {
  source                 = "github.com/nubisproject/nubis-terraform//storage?ref=v2.3.0"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  account                = "${var.account}"
  service_name           = "${var.service_name}"
  storage_name           = "${var.service_name}"
  client_security_groups = "${module.worker.security_group}"
}

module "backup" {
  source       = "github.com/nubisproject/nubis-terraform//bucket?ref=v2.3.0"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
  purpose      = "backup"
  role         = "${module.worker.role}"
}

module "cache" {
  source                 = "github.com/nubisproject/nubis-terraform//cache?ref=v2.3.0"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  account                = "${var.account}"
  service_name           = "${var.service_name}"
  client_security_groups = "${module.worker.security_group}"
}
