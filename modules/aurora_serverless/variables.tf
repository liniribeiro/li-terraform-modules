variable "create" {
  description = "Controls if resource should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "env" {
  description = "Deploy Environment"
  type        = string
}

variable "app_name" {
  default     = "template-service"
  description = "Name of this application"
  type        = string
}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "ID that identifies the VPC to use with RDS"
  type        = string
}

variable "db_instance_class" {
  description = "EC2 instance class to use for RDS instances"
  type        = string
  default     = "db.serverless"
}


variable "db_name" {
  description = "Name of the postgresql database. Defaults to var.app_name"
  type        = string
  default     = ""
}

variable "db_username" {
  description = "Name of user for the postgresql database. Defaults to var.app_name"
  type        = string
  default     = ""
}

variable "db_port" {
  description = "Network Port that DB will listen on"
  type        = string
  default     = 5432
}

variable "db_backup_retention_period" {
  type    = number
  default = 7
}

variable "db_engine_version" {
  description = "Engine version"
  type        = string
}

variable "allowed_security_groups" {
  description = "List of security group allowed to have db access"
  type        = list(string)
  default     = []
}



variable "db_acu_min_capacity" {
  type        = number
  description = "1 ACU means 2 GB of memory. It's possible 0.5 increments"
}

variable "db_acu_max_capacity" {
  type        = number
  description = "1 ACU means 2 GB of memory. It's possible 0.5 increments"
}

variable "db_seconds_until_pause" {
  description = "Seconds to auto pause the db when min capacity is 0 and db has no traffic"
  type        = number
  default     = null
}
