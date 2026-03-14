variable "name" {
  description = "Redis cluster name"
  type        = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "allowed_security_group_ids" {
  description = "Security groups allowed to connect to Redis"
  type        = list(string)
}

variable "node_type" {
  type    = string
  default = "cache.t3.small"
}

variable "engine_version" {
  type    = string
  default = "7.0"
}

variable "auth_token" {
  type      = string
  sensitive = true
}

variable "replica_count" {
  type    = number
  default = 1
}

variable "snapshot_retention_limit" {
  type    = number
  default = 7
}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}