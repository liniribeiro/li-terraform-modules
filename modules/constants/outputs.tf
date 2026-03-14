################################################################################
# Account Defaults
################################################################################
output "aws_region" {
  description = "The AWS region"
  value       = var.region
}

output "aws_account_id" {
  description = "AWS account id"
  value       = var.account_id
}


output "default_maintenance_window" {
  description = "Default maintenance window to use for clustered services"
  value       = local.default_maintenance_window
}

output "newrelic_license_ssm" {
  description = "SSM path to newrelice license"
  value       = local.newrelic_license_ssm
}
output "newrelic_license_ssm_arn" {
  description = "SSM path to newrelice license"
  value       = "arn:aws:ssm:${local.aws_region}:${local.aws_account_id}:parameter${local.newrelic_license_ssm}"
}

output "env_short_name" {
  description = "Short name for the provided env name"
  value       = try(local.env_short_name[var.env], var.env)
}

################################################################################
# VPCs and Subnets
################################################################################


output "root_dns" {
  description = "Root DNS used for all internal services"
  value       = local.root_dns
}

output "env_dns" {
  description = "Root DNS used for all internal services based upon env"
  value       = "${var.env}.${local.root_dns}"
}


################################################################################
# RDS Related Defaults
################################################################################
output "db_backup_retention_period" {
  description = "Number of days retention for DB backups/snapshots"
  value       = local.is_production ? local.prod.db_backup_retention_period : local.staging.db_backup_retention_period
}


################################################################################
# Networking Related Defaults
################################################################################


################################################################################
# ECR Defaults
################################################################################
output "ecr_url_dns" {
  description = "Region/Account DNS for manually constructing an ECR URL"
  value       = "${local.aws_account_id}.dkr.ecr.${local.aws_region}.amazonaws.com"
}

################################################################################
# ECS Defaults
################################################################################
output "autoscaling_min" {
  description = "Minimum number of instances for autoscaling"
  value       = local.is_production ? local.prod.autoscaling_min : local.staging.autoscaling_min
}

output "autoscaling_max" {
  description = "Maximum number of instances for autoscaling"
  value       = local.is_production ? local.prod.autoscaling_max : local.staging.autoscaling_max
}

output "autoscaling_target_cpu" {
  description = "Target CPU for autoscaling rules"
  value       = local.is_production ? local.prod.autoscaling_target_cpu : local.staging.autoscaling_target_cpu
}

################################################################################
# Node/Instance Class Defaults
################################################################################
output "redis_node_type" {
  description = "Instance node type"
  value       = local.is_production ? local.prod.redis_node_type : local.staging.redis_node_type
}

output "postgres_instance_class" {
  description = "Env default instance class for RDS postgres"
  value       = local.is_production ? local.prod.postgres_instance_class : local.staging.postgres_instance_class
}

################################################################################
# Common ARNs
################################################################################


################################################################################
# IAM Resource ARN prefixes
################################################################################
output "arn_prefix_cloudfront" {
  value = "arn:aws:cloudfront::${local.aws_account_id}"
}
output "arn_prefix_cloudfront_distribution" {
  value = "arn:aws:cloudfront::${local.aws_account_id}:distribution"
}

output "arn_prefix_dynamodb" {
  value = "arn:aws:dynamodb:${local.aws_region}:${local.aws_account_id}"
}
output "arn_prefix_dynamodb_table" {
  value = "arn:aws:dynamodb:${local.aws_region}:${local.aws_account_id}:table"
}

output "arn_prefix_ecr_repo" {
  value = "arn:aws:ecr:${local.aws_region}:${local.aws_account_id}:repository"
}

output "arn_prefix_ecs" {
  value = "arn:aws:ecs:${local.aws_region}:${local.aws_account_id}"
}
output "arn_prefix_ecs_cluster" {
  value = "arn:aws:ecs:${local.aws_region}:${local.aws_account_id}:cluster"
}
output "arn_prefix_ecs_service" {
  value = "arn:aws:ecs:${local.aws_region}:${local.aws_account_id}:service"
}

output "arn_prefix_glue" {
  value = "arn:aws:glue:${local.aws_region}:${local.aws_account_id}"
}
output "arn_prefix_glue_job" {
  value = "arn:aws:glue:${local.aws_region}:${local.aws_account_id}:job"
}

output "arn_prefix_kinesis_stream" {
  value = "arn:aws:kinesis:${local.aws_region}:${local.aws_account_id}:stream"
}

output "arn_prefix_iam" {
  value = "arn:aws:iam::${local.aws_account_id}"
}
output "arn_prefix_iam_role" {
  value = "arn:aws:iam::${local.aws_account_id}:role"
}
output "arn_prefix_iam_policy" {
  value = "arn:aws:iam::${local.aws_account_id}:policy"
}

output "arn_prefix_lambda" {
  value = "arn:aws:lambda:${local.aws_region}:${local.aws_account_id}"
}
output "arn_prefix_lambda_function" {
  value = "arn:aws:lambda:${local.aws_region}:${local.aws_account_id}:function"
}

output "arn_prefix_logs" {
  value = "arn:aws:logs:${local.aws_region}:${local.aws_account_id}"
}

output "arn_prefix_logs_log_group" {
  value = "arn:aws:logs:${local.aws_region}:${local.aws_account_id}:log-group"
}

output "arn_prefix_secretsmanager" {
  value = "arn:aws:secretsmanager:${local.aws_region}:${local.aws_account_id}"
}
output "arn_prefix_secretsmanager_secret" {
  value = "arn:aws:secretsmanager:${local.aws_region}:${local.aws_account_id}:secret"
}

output "arn_prefix_ssm_parameter" {
  value = "arn:aws:ssm:${local.aws_region}:${local.aws_account_id}:parameter"
}

output "arn_prefix_firehose" {
  value = "arn:aws:firehose:${local.aws_region}:${local.aws_account_id}"
}
output "arn_prefix_firehose_deliverystream" {
  value = "arn:aws:firehose:${local.aws_region}:${local.aws_account_id}:deliverystream"
}
