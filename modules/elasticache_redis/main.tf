
provider "aws" {
  region = var.region
}

locals {
  engine_version = coalesce(var.engine_version, "7.0")
  port           = coalesce(var.port, 6379)

  param_group_name = (var.create_param_group ?
    coalesce(var.param_group_name, "${var.app_name}.${local.engine_version}")
    : "default.redis7"
  )
}


resource "aws_security_group" "this" {
  count = var.create && var.create_sg ? 1 : 0

  name_prefix = "${var.app_name}-redis"
  description = "Allow Redis ports"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Security Groups that may use the cache"
    from_port       = local.port
    to_port         = local.port
    protocol        = "tcp"
    security_groups = coalesce(var.app_security_group_ids, [])
  }

  tags = var.tags
}


resource "aws_elasticache_cluster" "this" {
  count = var.create && !var.cluster_mode ? 1 : 0

  engine               = "redis"
  cluster_id           = var.cluster_name
  node_type            = var.node_type
  num_cache_nodes      = coalesce(var.num_cache_nodes, 1)
  parameter_group_name = local.param_group_name
  engine_version       = local.engine_version
  port                 = local.port
  availability_zone    = var.elasticache_subnet_id
  maintenance_window   = var.maintenance_window

  network_type      = coalesce(var.network_type, "ipv4")
  subnet_group_name = var.subnet_group_name

  security_group_ids = length(var.security_group_ids) > 0 ? var.security_group_ids : (var.create_sg ? [one(aws_security_group.this).id] : [])

  tags = var.tags
}


resource "aws_elasticache_parameter_group" "this" {
  count  = var.create && var.create_param_group ? 1 : 0
  name   = local.param_group_name
  family = coalesce(var.param_group_family, "default.redis7")

  dynamic "parameter" {
    for_each = var.cache_parameters != null ? var.cache_parameters : {}

    content {
      name  = paremeter.name
      value = paremeter.value
    }
  }

}
