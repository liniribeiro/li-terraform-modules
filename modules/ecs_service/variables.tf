variable "create" {
  description = "Conditional create all the resources in this module"
  type        = bool
  default     = true
}


variable "account_id" {
  description = "Aws account id"
  type        = string
}


variable "create_sg" {
  description = "Conditional create all the service security group in this module"
  type        = bool
  default     = true
}

variable "service_sg_id" {
  description = "Security Group id to use when create_sg = false"
  type        = string
  default     = null
}

variable "use_iam_short_names" {
  description = "Conditional use of new IAM naming convention"
  type        = bool
  default     = false
}

variable "region" {
  default     = "us-east-2"
  description = "AWS region"
  type        = string
}


variable "vpc_id" {
  description = "The environment VPC ID"
  type        = string
}


variable "env" {
  description = "Deploy Environment"
  type        = string
}

variable "ecs_cluster_name" {
  description = "Name of this ECS Cluster"
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

variable "iam_app_name" {
  description = "Name of this application for IAM resources"
  type        = string
  default     = ""
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

variable "container_definitions_json" {
  description = "Raw JSON definition of the containers"
  type        = string
  default     = null
}

variable "efs_volume_configuration" {
  description = "A representation of efs volumes that will be added into a task"
  type = list(object({
    name           = string
    file_system_id = string
    root_directory = optional(string, "/")
  }))
  default = null
}

variable "task_cpu" {
  description = "Task cpu (must be greater than sum of container cpu values)"
  type        = number
  default     = null
}

variable "task_memory" {
  description = "Task memory of all containers in the task"
  type        = number
  default     = null
}

variable "autoscaling" {
  type = object({
    enabled           = optional(bool, false)
    min_capacity      = optional(number, 1)
    max_capacity      = optional(number, 1)
    create_target_cpu = optional(bool, true)
    target_cpu        = optional(number, 50)
  })

  default = {}

  validation {
    condition     = var.autoscaling.min_capacity > 0 && var.autoscaling.min_capacity <= 50
    error_message = "The autoscaling.min_capacity value must be between 1 and 50"
  }

  validation {
    condition     = var.autoscaling.max_capacity >= var.autoscaling.min_capacity && var.autoscaling.max_capacity <= 50
    error_message = "The autoscaling.max_capacity value must be between ${var.autoscaling.min_capacity} and 50"
  }

  validation {
    condition     = var.autoscaling.target_cpu > 0 && var.autoscaling.target_cpu < 100
    error_message = "Autoscaling target_cpu must be between 1 and 99"
  }
}


variable "capacity_provider_strategy" {
  description = "Capacity provider strategies to use for the service. Can be one or more"
  type        = any
  default     = {}
}


variable "service_replicas" {
  type        = number
  default     = 1
  description = "Number of replicas for the launched service"
}

variable "load_balancers" {
  description = "Description of load_balancer to attach to service"
  default     = []
  type = list(object({
    container_name    = optional(string, null)
    target_group_arn  = string
    target_group_port = number
  }))
}

variable "security_group_names" {
  description = "Security Groups to associate with the service container"
  type        = list(string)
}

variable "service_discovery_clients" {
  description = "List of env named ECS services that should be allowed to access using service discovery"
  type        = list(string)
  default     = null
}

variable "service_discovery_ns_id" {
  description = "ID that identifies the Service Discovery Namespace"
  type        = string
}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}


variable "execution_policy_arns" {
  description = "List of policy ARNs to attach to the created Execution role"
  type        = list(string)
  default     = []
}

variable "task_policy_arns" {
  description = "List of policy ARNs to attach to the created Task role"
  type        = list(string)
  default     = []
}


variable "deployment_minimum_healthy_percent" {
  description = "Minimum percent of healthy instances when deploy"
  type        = number
  default     = null
}


variable "deployment_maximum_percent" {
  description = "Max percent of healthy instances when deploy"
  type        = number
  default     = null
}
