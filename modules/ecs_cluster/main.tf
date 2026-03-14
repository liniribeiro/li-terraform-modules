provider "aws" {
  region = var.region
}

locals {
  cluster_name = "${var.env}-${var.app_name}"

  tags = merge(
    {
      "Environment"  = format("%s", var.env)
      "CostResource" = format("%s", var.app_name)
    },
    var.tags,
  )
}


################################################################################
# Ecs Module
################################################################################
module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = ">6.0.0"
  region = var.region
  cluster_name = local.cluster_name
  create = var.create
  cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days

  default_capacity_provider_strategy = var.fargate_capacity_providers

  cluster_service_connect_defaults = (
    var.service_connect_default_namespace_arn != null
    ? {
        namespace = var.service_connect_default_namespace_arn
      }
    : null
  )

  cluster_setting = [{
    "name" : "containerInsights",
    "value" : (var.enable_container_insights ? "enabled" : "disabled")
  }]

  tags = local.tags

}
