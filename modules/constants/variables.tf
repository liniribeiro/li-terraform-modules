variable "env" {
  description = "Deploy Environment"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-2"
}

variable "account_id" {
  description = "Aws account id"
  type        = string
}
