variable "create" {
  description = "Conditional create all the resources in this module"
  type        = bool
  default     = false
}

variable "region" {
  default     = "us-east-2"
  description = "AWS region"
  type        = string
}

variable "env" {
  description = "Deploy Environment"
  type        = string
}

variable "app_name" {
  description = "Name of this application. E.g. 'listicle'"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}


variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}

################################################################################
# Security Groups
################################################################################
variable "create_sg" {
  description = "Conditionally create a security group to control cache access"
  type        = bool
  default     = true
}

variable "app_security_group_ids" {
  description = "List of security group ids that are granted port access to the cache"
  type        = list(string)
  default     = null
}

variable "security_group_ids" {
  description = "Security group ids to override the default security group"
  type        = list(string)
  default     = []
}

################################################################################
# Cache variables
################################################################################

variable "cluster_mode" {
  description = "Redis cluster vs single instance"
  type        = bool
  default     = false
}

variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
  default     = null
}

variable "num_cache_nodes" {
  description = "Number of nodes in the cluster"
  type        = number
  default     = null
}

variable "node_type" {
  description = "Cache instance type"
  type        = string
  default     = null
}

variable "elasticache_subnet_id" {
  description = "Subnet ID of where to place the elasticache instance"
  type        = string
  default     = null
}

variable "subnet_group_name" {
  description = "Name of the Subnet group"
  type        = string
  default     = null
}


variable "port" {
  description = "Redis connection port"
  type        = number
  default     = null
}


variable "create_param_group" {
  description = "Conditionally create the cache parameter group"
  type        = bool
  default     = false
}

variable "param_group_name" {
  description = "Name of the cache parameter group"
  type        = string
  default     = null
}

variable "param_group_family" {
  description = "Name of the parameter group family (e.g default.redis7)"
  type        = string
  default     = null
}

variable "cache_parameters" {
  description = "Map of name=value redis parameter group values"
  type        = map(any)
  default     = null
}


variable "maintenance_window" {
  description = "The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC)"
  type        = string
  default     = null
}

variable "network_type" {
  description = "ipv4, ipv6, or dualstack"
  type        = string
  default     = null
}

variable "engine_version" {
  description = "Redis engine version"
  type        = string
  default     = "7.0"
}
