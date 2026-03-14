output "rds_sg_ids" {
  description = "RDS security groups IDs"
  value       = try([aws_security_group.sg_rds[0].id], [])
}

output "db_name" {
  description = "Name of the DB"
  value       = try(module.aurora_postgresql_v2[0].cluster_database_name, null)
}

output "db_writer_endpoint" {
  description = "Writer endpoint"
  value       = try(module.aurora_postgresql_v2[0].cluster_endpoint, null)
}

output "db_reader_endpoint" {
  description = "Reader endpoint"
  value       =  try(module.aurora_postgresql_v2[0].cluster_reader_endpoint, null)
}
