locals {
  aws_region     = var.region
  aws_account_id = var.account_id

  is_production = var.env == "production"

  root_dns = "pvt.liniatech.com"

  default_maintenance_window = "mon:00:00-mon:03:00"

  newrelic_license_ssm = "/dev/newrelic_license"


  env_short_name = {
    "development" = "dev"
    "infra"       = "infra"
    "staging"     = "stage"
    "production"  = "prod"
  }
}
