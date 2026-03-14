variable "create" {
  description = "Controls if ECR should be created (it affects almost all resources)"
  type        = bool
  default     = true
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

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "Number of days to retain logs for the cluster cloudwatch log group."
  type        = number
  default     = 7
}


variable "fargate_capacity_providers" {
  description = "Map of Fargate capacity provider definitions to use for the cluster"
  type        = any
  default     = null
}


variable "enable_container_insights" {
  description = "Enable container insights for the cluster"
  type        = bool
  default     = false
}

variable "service_connect_default_namespace_arn" {
  description = "ARN that identifies the default namespace for service connect"
  type        = string
  default     = null
}
