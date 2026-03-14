locals {
  env_short_name_map = {
    "staging"    = "stage",
    "production" = "prod",
  }

  env_short_name = try(local.env_short_name_map[var.env], substr(var.env, 0, 5))
  app_short_name = var.app_short_name != null ? var.app_short_name : var.app_name


  app_env_name       = "${var.env}-${var.app_name}"
  app_env_short_name = "${local.env_short_name}-${local.app_short_name}"

  app_name_underscore       = replace(var.app_name, "-", "_")
  app_short_name_underscore = replace(local.app_short_name, "-", "_")

  app_title_name = replace(title(replace(var.app_name, "-", " ")), " ", "")
}

output "app_name" {
  value = var.app_name
}

output "app_name_underscore" {
  value = local.app_name_underscore
}

output "app_short_name" {
  value = local.app_short_name
}

output "app_short_name_underscore" {
  value = local.app_short_name_underscore
}

output "env_name" {
  value = var.env
}

output "env_short_name" {
  value = local.env_short_name
}

output "env_app_name" {
  value = local.app_env_name
}

output "env_app_short_name" {
  value = local.app_env_short_name
}

output "env_ecs_cluster_name" {
  value = "${var.env}-${var.app_name}"
}

output "role_prefix_ecs_task_exec" {
  value = "Exe-${local.app_env_short_name}"
}

output "role_prefix_ecs_runtime" {
  value = "Run-${local.app_env_short_name}"
}

output "role_prefix_app" {
  value = "App-${local.app_env_short_name}"
}

output "policy_prefix_ecs_task_exec" {
  value = "ExePol-${local.app_env_short_name}"
}

output "policy_prefix_ecs_runtime" {
  value = "RunPol-${local.app_env_short_name}"
}

output "policy_prefix_app" {
  value = "AppPol-${local.app_env_short_name}"
}

output "policy_prefix_sagemaker" {
  value = "Sagemaker-${local.app_env_short_name}"
}

output "policy_prefix_datasync" {
  value = "Datasync-${local.app_env_short_name}"
}

output "iam_deploy_role_name" {
  value = "CircleRole-${local.app_title_name}"
}
