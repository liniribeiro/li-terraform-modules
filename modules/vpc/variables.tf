variable "create" {
  description = "Conditionally create the resources"
  type        = bool
  default     = true
}


variable "account_id" {
  description = "Aws account id"
  type        = string
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

variable "app_short_name" {
  description = "Name of this application. E.g. 'listicle'"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}

variable "extra_sg_cidrs" {
  description = "A list of CIDRs to allow HTTPS access"
  type        = list(string)
  default     = []
}

variable "private_root_dns" {
  description = "Name of the private hosted zone root DNS"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "The environment VPC ID"
  type        = string
}

variable "target_group_port" {
  description = "Target Group port number for the service"
  type        = number
  default     = 80
}

variable "target_group_protocol" {
  description = "Target Group protocol for the service"
  type        = string
  default     = "HTTP"
}

variable "target_group_health_config" {
  description = "Target Group health check information"
  default = {
    port                = 80
    path                = "/"
    healthy_threshold   = 6
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = "200"
  }
  type = object({
    port                = number
    path                = string
    healthy_threshold   = number
    unhealthy_threshold = number
    timeout             = number
    interval            = number
    matcher             = string
  })
}
