variable "account" {
  default = "appsvcs-securitywiki"
}

variable "region" {
  default = "us-west-2"
}

variable "environment" {
  default = "stage"
}

variable "service_name" {
  default = "appsvcs-securitywiki"
}

variable "ami" {}

variable "health_check_target" {
  default = "HTTP:81/"
}
