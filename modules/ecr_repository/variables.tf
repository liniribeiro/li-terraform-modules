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
  default     = "production"
  description = "Deploy Environment"
  type        = string
}

variable "account_id" {
  description = "Aws account id"
  type        = string
}


variable "app_name" {
  description = "Name of this application. E.g. 'listicle'"
  type        = string
}

variable "repo_name" {
  description = "Name of the repo. E.g. 'listicle-app'"
  type        = string
}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}


################################################################################
# ECR Policy Related Variables
################################################################################

variable "repo_policy" {
  description = "JSON policy to associate with the repository"
  type        = string
  default     = null
}

variable "policy_allow_lambda" {
  description = "If true, create a repo policy that allows lambda to pull ECR from this repo"
  type        = bool
  default     = false
}
