variable "create" {
  description = "Conditional create all the resources in this module"
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

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}

variable "performance_mode" {
  description = "EFS performance mode"
  type        = string
  default     = "generalPurpose"
}

variable "name" {
  description = "EFS name"
  type        = string
}

variable "throughput_mode" {
  description = "EFS throughput mode"
  type        = string
  default     = "bursting"
}

variable "vpc_id" {
  description = "The environment VPC ID"
  type        = string
}

variable "default_vpc_sg" {
  description = "Default VPC Security Group"
  type        = string
}
