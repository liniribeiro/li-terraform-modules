################################################################################
# Production
################################################################################
locals {
  prod = {
    autoscaling_min            = 2
    autoscaling_max            = 5
    autoscaling_target_cpu     = 50
    db_backup_retention_period = 20

    redis_node_type         = "cache.r6g.large"
    postgres_instance_class = "db.t4g.small"

  }
}
