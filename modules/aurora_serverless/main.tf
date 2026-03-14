data "aws_ssm_parameter" "rds_password" {
  name            = "/${var.env}/${var.app_name}/rds-password"
  with_decryption = true
}

module "name" {
  source = "../naming"

  env            = var.env
  app_name       = var.app_name
  app_short_name = var.app_name
}

locals {
  full_name = "${var.env}-${var.app_name}"

  db_name     = replace(var.db_name != null ? var.db_name : var.app_name, "-", "_")
  db_username = replace(var.db_username != "" ? var.db_username : var.app_name, "-", "_") # Can't use hyphens

  tags = merge(
    {
      "Environment"  = format("%s", var.env)
      "CostResource" = format("%s", var.app_name)
    },
    var.tags,
  )
}

################################################################################
# PostgreSQL Serverless v2
################################################################################
module "aurora_postgresql_v2" {
  count = var.create ? 1 : 0

  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "9.16.1"

  name                        = "${local.full_name}-aurora-cluster"
  engine                      = "aurora-postgresql"
  engine_mode                 = "provisioned"
  engine_version              = var.db_engine_version
  storage_encrypted           = true
  master_username             = local.db_username
  master_password             = data.aws_ssm_parameter.rds_password.value
  manage_master_user_password = false
  database_name               = local.db_name

  create_db_parameter_group = false
  create_db_subnet_group    = false
  create_security_group     = false

  vpc_id                 = var.vpc_id
  db_subnet_group_name   = var.env
  vpc_security_group_ids = [aws_security_group.sg_rds[count.index].id]

  iam_role_name                        = "${module.name.role_prefix_app}-rds-monitoring"
  cluster_monitoring_interval          = 60
  cluster_performance_insights_enabled = true


  apply_immediately   = true
  skip_final_snapshot = true

  enable_http_endpoint = false

  instance_class = var.db_instance_class
  instances = {
    one = {}
  }

  backup_retention_period = var.db_backup_retention_period

  serverlessv2_scaling_configuration = {
    max_capacity             = var.db_acu_max_capacity
    min_capacity             = var.db_acu_min_capacity
    seconds_until_auto_pause = var.db_seconds_until_pause
  }

  tags = local.tags
}


resource "aws_security_group" "sg_rds" {
  count = var.create ? 1 : 0

  name_prefix = "${local.full_name}-rds"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description     = "PostgreSQL access from specific security groups"
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = var.allowed_security_groups
  }

}
