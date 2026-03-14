
variable "env" {
  description = "Deploy Environment"
  type        = string
}

variable "app_name" {
  description = "Name of this application. E.g. 'template-service'"
  type        = string
}

variable "app_short_name" {
  description = "Shorter name of this application. E.g. 'template'"
  type        = string
  default     = null
}
