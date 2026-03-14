output "task_name" {
  description = "Task Family"
  value       = try(aws_ecs_task_definition.app[0].family, null)
}

output "task_arn" {
  description = "ARN that identifies the Task Definition"
  value       = try(aws_ecs_task_definition.app[0].arn, null)
}
