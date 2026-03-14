output "service_name" {
  description = "Name of the Service"
  value       = try(aws_ecs_service.service[0].name, null)
}

output "service_sg_name" {
  description = "Name of the Service's Security Group"
  value       = try(aws_security_group.service[0].name, null)
}

output "service_sg_arn" {
  description = "ARN that identifies the Service's Security Group"
  value       = try(aws_security_group.service[0].arn, null)
}

output "service_sg_id" {
  description = "ID that identifies the Service's Security Group"
  value       = try(aws_security_group.service[0].id, var.service_sg_id, null)
}

output "execution_role_arn" {
  value       = try(aws_iam_role.execution[0].arn, null)
  description = "ARN that identifies the Service's Task Definition Execution Role"
}

output "task_role_arn" {
  value       = try(aws_iam_role.task[0].arn, null)
  description = "ARN that identifies the Service's Task Definition Task Role"
}


output "autoscaling_target" {
  value       = try(aws_appautoscaling_target.service[0], null)
  description = "The autoscaling target to be used for adding more autoscaling policies"
}
