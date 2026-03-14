################################################################################
# Staging
################################################################################
locals {

  staging = {
    autoscaling_min            = 1
    autoscaling_max            = 5
    autoscaling_target_cpu     = 50
    db_backup_retention_period = 7

    redis_node_type         = "cache.t4g.small"
    postgres_instance_class = "db.t4g.small"
  }
}
