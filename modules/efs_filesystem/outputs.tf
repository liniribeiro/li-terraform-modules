################################################################################
# EFS
################################################################################

output "creation_token" {
  description = "EFS creation token"
  value       = aws_efs_file_system.this.creation_token
}

output "tags" {
  description = "EFS tags"
  value       = aws_efs_file_system.this.tags
}

output "throughput_mode" {
  description = "EFS throughput mode"
  value       = aws_efs_file_system.this.throughput_mode
}

output "performance_mode" {
  description = "EFS performance mode"
  value       = aws_efs_file_system.this.performance_mode
}

output "file_system_id" {
  description = "EFS file system id"
  value       = aws_efs_file_system.this.id
}

output "file_system_arn" {
  value = aws_efs_file_system.this.arn
}

output "id" {
  value = aws_efs_file_system.this.id
}
