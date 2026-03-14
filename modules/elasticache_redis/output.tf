output "arn" {
  value = try(aws_elasticache_cluster.this[0].arn, null)
}

output "engine_version_actual" {
  value = try(aws_elasticache_cluster.this[0].engine_version_actual, null)
}

output "cluster_address" {
  value = try(aws_elasticache_cluster.this[0].cluster_address, null)
}

output "configuration_endpoint" {
  value = try(aws_elasticache_cluster.this[0].configuration_endpoint, null)
}

output "cache_nodes" {
  value = try(aws_elasticache_cluster.this[0].cache_nodes, null)
}
