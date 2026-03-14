module "name" {
  source = "../naming"
  env    = var.env
  app_name = var.app_name
}

module "const" {
  source = "../constants"
  env    = var.env
  account_id = var.account_id
}


locals {
  env_sub_app_name = "${var.env}-${var.sub_app_name}"

  tags = merge(
    {
      terraform_deployment = "app_service"
      CostResource         = var.app_name
      CostSubResource      = var.sub_app_name
      Environment          = var.env
      "ECSClusterName"     = var.ecs_cluster_name
    },
    var.tags,
  )
}


data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    Name = "${var.env}-private-*"
  }
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

data "aws_security_groups" "passed" {
  count = var.create_sg ? 1 : 0
  filter {
    name   = "group-name"
    values = coalesce(var.security_group_names, [])
  }
}

data "aws_security_groups" "service_discovery_clients" {
  count = var.create_sg && length(coalesce(var.service_discovery_clients, [])) > 0 ? 1 : 0
  filter {
    name   = "group-name"
    values = coalesce(var.service_discovery_clients, [])
  }
}

data "aws_security_group" "service_discovery_clients" {
  for_each = toset(try(data.aws_security_groups.service_discovery_clients[0].ids, []))

  id = each.value
}


################################################################################
# Cloudwatch service group
################################################################################
resource "aws_cloudwatch_log_group" "this" {
  count             = var.create ? 1 : 0
  name              = "/aws/ecs/${var.ecs_cluster_name}/${var.sub_app_name}"
  retention_in_days = 7
  tags              = local.tags
}


################################################################################
# Task Definition App
################################################################################

module "app_task" {
  source = "../ecs_task_definition"

  create = var.create

  app_name                  = var.app_name
  sub_app_name              = var.sub_app_name
  account_id = var.account_id
  cloudwatch_log_group_name = try(aws_cloudwatch_log_group.this[0].name, null)
  env                       = var.env
  task_cpu                  = var.task_cpu
  task_memory               = var.task_memory
  task_network_mode         = "awsvpc"

  task_role_arn      = try(aws_iam_role.task[0].arn, null)
  execution_role_arn = try(aws_iam_role.execution[0].arn, null)


  container_definitions_json = var.container_definitions_json
  efs_volume_configuration   = var.efs_volume_configuration

  newrelic_app_name    = var.newrelic_app_name
  add_newrelic_sidecar = var.add_newrelic_sidecar

  tags = local.tags
}

################################################################################
# Security Groups
################################################################################

resource "aws_security_group" "service" {
  count = var.create && var.create_sg ? 1 : 0

  name   = "${local.env_sub_app_name}-service"
  vpc_id = var.vpc_id

  ingress {
    description = "HTTP from LB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [
      "10.50.0.0/16", # Infra VPC
    ]
    security_groups = try(data.aws_security_groups.passed[0].ids, [])
  }

  dynamic "ingress" {
    for_each = { for sg in data.aws_security_group.service_discovery_clients : sg.name => sg.id }

    content {
      description = "${ingress.key} - Service Discovery Direct"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = []
      security_groups = [
        ingress.value
      ]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = local.tags
}

################################################################################
# Service Discovery
################################################################################
resource "aws_service_discovery_service" "this" {
  # No ENV in name. ENV is in the namespace (domain)
  name = var.sub_app_name

  count = var.create ? 1 : 0

  dns_config {
    namespace_id = var.service_discovery_ns_id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  tags = local.tags
}

################################################################################
# Service
################################################################################

resource "aws_ecs_service" "service" {
  count = var.create ? 1 : 0

  name            = local.env_sub_app_name
  cluster         = var.ecs_cluster_name
  launch_type     = length(var.capacity_provider_strategy) > 0 ? null : "FARGATE"
  task_definition = module.app_task.task_arn
  desired_count   = var.service_replicas
  # iam_role        = aws_iam_role.task.arn

  network_configuration {
    security_groups = var.create_sg ? [aws_security_group.service[0].id] : [var.service_sg_id]
    subnets         = [for subnet in data.aws_subnet.private : subnet.id]
  }

  dynamic "load_balancer" {
    for_each = toset(var.load_balancers)

    content {
      container_name   = coalesce(load_balancer.value.container_name, var.sub_app_name)
      target_group_arn = load_balancer.value.target_group_arn
      container_port   = load_balancer.value.target_group_port
    }
  }

  dynamic "capacity_provider_strategy" {
    # Set by task set if deployment controller is external
    for_each = { for k, v in var.capacity_provider_strategy : k => v }

    content {
      base              = try(capacity_provider_strategy.value.base, null)
      capacity_provider = capacity_provider_strategy.value.capacity_provider
      weight            = try(capacity_provider_strategy.value.weight, null)
    }
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  service_registries {
    registry_arn = try(aws_service_discovery_service.this[0].arn)
  }

  enable_ecs_managed_tags = true
  propagate_tags          = "SERVICE"

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }

  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent
  tags                               = local.tags
}


resource "aws_appautoscaling_target" "service" {
  count              = var.create && var.autoscaling.enabled ? 1 : 0
  max_capacity       = var.autoscaling.max_capacity
  min_capacity       = var.autoscaling.min_capacity
  resource_id        = "service/${var.ecs_cluster_name}/${local.env_sub_app_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "service-cpu" {
  count = var.create && var.autoscaling.enabled && var.autoscaling.create_target_cpu ? 1 : 0

  name               = "${local.env_sub_app_name}-TargetTrackingAvgCPU"
  policy_type        = "TargetTrackingScaling"
  resource_id        = try(aws_appautoscaling_target.service[0].resource_id)
  scalable_dimension = try(aws_appautoscaling_target.service[0].scalable_dimension)
  service_namespace  = try(aws_appautoscaling_target.service[0].service_namespace)

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = var.autoscaling.target_cpu
  }
}
