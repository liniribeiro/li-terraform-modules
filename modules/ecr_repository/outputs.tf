################################################################################
# Repository
################################################################################

output "registry_id" {
  description = "ID that identifies the registry"
  value       = try(aws_ecr_repository.ecr[0].registry_id, null)
}

output "arn" {
  description = "ARN that identifies the repository"
  value       = try(aws_ecr_repository.ecr[0].arn, null)
}

output "repository_url" {
  description = "The URL of the repository (in the form aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName)"
  value       = try(aws_ecr_repository.ecr[0].repository_url, null)
}

output "name" {
  description = "Name of the repository"
  value       = try(aws_ecr_repository.ecr[0].name, null)
}
