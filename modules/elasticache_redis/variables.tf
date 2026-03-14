variable "create" {
  description = "Conditional create all the resources in this module"
  type        = bool
  default     = true
}

variable "name" {
  description = "Redis replication group id"
  type        = string
}

variable "vpc_id" {
  description = "VPC where Redis will run"
  type        = string
}

variable "subnet_ids" {
  description = "Private subnets for Redis"
  type        = list(string)
}

variable "allowed_security_group_ids" {
  description = "Security groups allowed to connect to Redis"
  type        = list(string)
}

variable "node_type" {
  description = "Instance type"
  type        = string
  default     = "cache.t3.small"
}

variable "engine_version" {
  description = "Redis version"
  type        = string
  default     = "7.0"
}

variable "replica_count" {
  description = "Number of replicas"
  type        = number
  default     = 1
}

variable "auth_token" {
  description = "Redis AUTH token"
  type        = string
  sensitive   = true
}

variable "snapshot_retention_limit" {
  description = "Days to keep backups"
  type        = number
  default     = 7
}

variable "tags" {
  type    = map(string)
  default = {}
}