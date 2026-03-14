variable "create" {
  description = "Conditional create all the resources in this module"
  type        = bool
  default     = true
}

variable "account_id" {
  description = "Aws account id"
  type        = string
}


variable "create_task_def" {
  description = "Conditional create the task definition in this module"
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
  description = "Name of this application"
  type        = string
}

variable "sub_app_name" {
  description = "Name of this application"
  type        = string
}

variable "task_cpu" {
  type        = number
  description = "CPU"
  default     = 256
}

variable "task_memory" {
  type        = number
  description = "Memory"
  default     = 512
}

variable "task_network_mode" {
  type        = string
  description = "Network Mode for the task (host, bridge, awsvpc)"
  default     = "awsvpc"
}

variable "newrelic_app_name" {
  type        = string
  description = "Name of the newrelic app (APM). Defaults to '<app_name> (<env>)'"
  default     = null
}

variable "add_newrelic_sidecar" {
  type        = bool
  description = "Inject the newrelic sidecar container in to the task definition"
  default     = false
}

variable "efs_volume_configuration" {
  description = "A representation of efs volumes that will be added into a task"
  type = list(object({
    name           = string
    file_system_id = string
    root_directory = string
  }))
  default = null
}

variable "container_definitions_json" {
  description = "Raw JSON definition of the containers"
  type        = string
  default     = null
}

variable "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch Log Group"
  type        = string
}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}

variable "execution_role_arn" {
  description = "ARN that identifies the Task execution role"
  type        = string
}

variable "task_role_arn" {
  description = "ARN that identifies the Task role"
  type        = string
}
