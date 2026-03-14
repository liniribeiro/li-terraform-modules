provider "aws" {
  region = var.region

}

locals {
  env_sub_app_name = "${var.env}-${var.sub_app_name}"
  tags = merge(
    {
      terraform_deployment = "app_task"
      CostResource         = var.app_name
      CostSubResource      = var.sub_app_name
      Environment          = var.env
    },
    var.tags
  )

  newrelic_sidecar = !var.add_newrelic_sidecar ? [] : [{
    name   = "newrelic-infra"
    image  = "newrelic/nri-ecs:1.10.3"
    cpu    = 256
    memory = 512
    secrets = [
      {
        "name" : "NRIA_LICENSE_KEY",
        "valueFrom" : module.const.newrelic_license_ssm_arn
      }
    ],
    environment = [
      {
        "name" : "NEW_RELIC_APP_NAME",
        "value" : coalesce(var.newrelic_app_name, "${title(var.app_name)} (${title(var.env)})")
      },
      # {
      #   "name": "NRIA_LICENSE_KEY",
      #   "value": "432662530909755ca00204a478cc8dd47bcb51f9"
      # },
      {
        "name" : "NRIA_OVERRIDE_HOST_ROOT",
        "value" : ""
      },
      {
        "name" : "NRIA_IS_FORWARD_ONLY",
        "value" : "true"
      },
      {
        "name" : "FARGATE",
        "value" : "true"
      },
      {
        "name" : "NRIA_SYSTEMD_INTERVAL_SEC",
        "value" : "-1",
      },
      {
        "name" : "NRIA_LOG_LEVEL",
        "value" : "debug"
      },
      {
        "name" : "NRIA_PASSTHROUGH_ENVIRONMENT",
        "value" : "ECS_CONTAINER_METADATA_URI,ECS_CONTAINER_METADATA_URI_V4,FARGATE"
      },
      {
        "name" : "NRIA_CUSTOM_ATTRIBUTES",
        "value" : "{\"nrDeployMethod\":\"downloadPage\", \"env\":\"${module.const.env_short_name}\",\"CostResource\":\"${var.app_name}\"}"
      }
    ],
    logConfiguration : {
      logDriver : "awslogs",
      options : {
        awslogs-region : var.region
        awslogs-group : "${var.cloudwatch_log_group_name}-newrelic"
        awslogs-stream-prefix : "ecs"
      },
    }
  }]

  containers = []

}

module "const" {
  source = "../constants"
  env    = var.env
  account_id = var.account_id
}


################################################################################
# New relic log specific
################################################################################
resource "aws_cloudwatch_log_group" "newrelic" {
  count             = var.create && var.add_newrelic_sidecar ? 1 : 0
  name              = "${var.cloudwatch_log_group_name}-newrelic"
  retention_in_days = 1
  tags              = local.tags
}

################################################################################
# Task Definition App
################################################################################

resource "aws_ecs_task_definition" "app" {
  count                    = var.create && var.create_task_def ? 1 : 0
  family                   = local.env_sub_app_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = var.task_network_mode
  task_role_arn            = var.task_role_arn
  execution_role_arn       = var.execution_role_arn
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  container_definitions = (
    var.container_definitions_json != null ? var.container_definitions_json : jsonencode(concat(local.containers, local.newrelic_sidecar))
  )
  tags = local.tags

  #Using a single value as list, to ensure that if the object is null, the block will not be created.
  dynamic "volume" {
    for_each = var.efs_volume_configuration != null ? var.efs_volume_configuration[*] : []
    content {
      name = volume.value["name"]
      efs_volume_configuration {
        file_system_id = volume.value["file_system_id"]
        root_directory = volume.value["root_directory"]
      }
    }
  }

  lifecycle {
    ignore_changes = [
      container_definitions
    ]
  }

}
