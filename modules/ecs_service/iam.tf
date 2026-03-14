locals {
  number_of_execution_policy_arns = length(var.execution_policy_arns)

  number_of_task_policy_arns = length(var.task_policy_arns)

  env_iam_app_name = var.iam_app_name != "" ? "${var.env}-${var.iam_app_name}" : local.env_sub_app_name
}

################################################################################
# Execution Role
################################################################################
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "execution" {
  count              = var.create ? 1 : 0
  name               = var.use_iam_short_names ? "Exe-${module.name.env_short_name}-${var.sub_app_name}" : "ECSRuntimeExecution-${local.env_iam_app_name}"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = local.tags
}


resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attach" {
  count      = var.create ? 1 : 0
  role       = aws_iam_role.execution[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "execution_custom" {
  count = var.create ? local.number_of_execution_policy_arns : 0

  role       = aws_iam_role.execution[0].name
  policy_arn = var.execution_policy_arns[count.index]
}

################################################################################
# Task Role
################################################################################

resource "aws_iam_role" "task" {
  count              = var.create ? 1 : 0
  name               = var.use_iam_short_names ? "Run-${module.name.env_short_name}-${var.sub_app_name}" : "ECSRuntimeTask-${local.env_iam_app_name}"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "task_custom" {
  count = var.create ? local.number_of_task_policy_arns : 0

  role       = aws_iam_role.task[0].name
  policy_arn = var.task_policy_arns[count.index]
}
