output "primary_endpoint" {
  description = "Redis primary endpoint"
  value       = try(aws_elasticache_replication_group.redis[0].primary_endpoint_address, null)
}

output "reader_endpoint" {
  description = "Redis reader endpoint"
  value       = try(aws_elasticache_replication_group.redis[0].reader_endpoint_address, null)
}

output "security_group_id" {
  value = try(aws_security_group.redis[0].id, null)
}