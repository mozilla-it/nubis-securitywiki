module "worker" {
  source            = "github.com/nubisproject/nubis-terraform//worker?ref=v1.3.0"
  region            = "${var.region}"
  environment       = "${var.environment}"
  account           = "${var.account}"
  service_name      = "${var.service_name}"
  purpose           = "webserver"
  ami               = "${var.ami}"
  elb               = "${module.load_balancer.name}"
  min_instances     = 1
  nubis_sudo_groups = "team_webops,nubis_global_admins"
}

module "load_balancer" {
  source              = "github.com/nubisproject/nubis-terraform//load_balancer?ref=v1.3.0"
  region              = "${var.region}"
  environment         = "${var.environment}"
  account             = "${var.account}"
  service_name        = "${var.service_name}"
  health_check_target = "HTTP:443/"
}

module "database" {
  source                 = "github.com/nubisproject/nubis-terraform//database?ref=v1.3.0"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  account                = "${var.account}"
  service_name           = "${var.service_name}"
  client_security_groups = "${module.worker.security_group}"
}

module "dns" {
  source       = "github.com/nubisproject/nubis-terraform//dns?ref=v1.3.0"
  region       = "${var.region}"
  environment  = "${var.environment}"
  account      = "${var.account}"
  service_name = "${var.service_name}"
  target       = "${module.load_balancer.address}"
}

module "storage" {
  source                 = "github.com/nubisproject/nubis-terraform//storage?ref=v1.3.0"
  region                 = "${var.region}"
  environment            = "${var.environment}"
  account                = "${var.account}"
  service_name           = "${var.service_name}"
  storage_name           = "${var.service_name}"
  client_security_groups = "${module.worker.security_group},${module.queue-worker.security_group},${module.push-worker.security_group}"
}
