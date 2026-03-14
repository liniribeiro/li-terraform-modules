################################################################################
# Cluster
################################################################################

output "cluster_arn" {
  description = "ARN that identifies the cluster"
  value       = module.ecs.cluster_arn
}

output "cluster_id" {
  description = "ID that identifies the cluster"
  value       = module.ecs.cluster_id
}

output "cluster_name" {
  description = "Name that identifies the cluster"
  value       = module.ecs.cluster_name
}

################################################################################
# CloudWatch Log Group
################################################################################

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch Log Group"
  value       = module.ecs.cloudwatch_log_group_name
}

output "cloudwatch_log_group_arn" {
  description = "ARN that identifies the CloudWatch Log Group"
  value       = module.ecs.cloudwatch_log_group_arn
}
