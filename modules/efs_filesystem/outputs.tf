################################################################################
# EFS
################################################################################

output "creation_token" {
  description = "EFS creation token"
  value       = try(aws_efs_file_system.this[0].creation_token, null)
}

output "tags" {
  description = "EFS tags"
  value       = try(aws_efs_file_system.this[0].tags, null)
}

output "throughput_mode" {
  description = "EFS throughput mode"
  value       = try(aws_efs_file_system.this[0].throughput_mode, null)
}

output "performance_mode" {
  description = "EFS performance mode"
  value       = try(aws_efs_file_system.this[0].performance_mode, null)
}

output "file_system_id" {
  description = "EFS file system id"
  value       = try(aws_efs_file_system.this[0].id, null)
}

output "file_system_arn" {
  value = try(aws_efs_file_system.this[0].arn, null)
}

output "id" {
  value = try(aws_efs_file_system.this[0].id, null)
}
