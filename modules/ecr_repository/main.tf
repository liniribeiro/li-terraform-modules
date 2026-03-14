provider "aws" {
  region = var.region

}


resource "aws_ecr_repository" "ecr" {
  count = var.create ? 1 : 0
  name  = var.repo_name

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(
    {
      # Shared repo - it's prod
      "Environment"  = var.env
      "CostResource" = format("%s", var.app_name)
    },
    var.tags,
  )
}


################################################################################
# Lifecycle Policy
################################################################################
resource "aws_ecr_lifecycle_policy" "cleanup" {
  count = var.create ? 1 : 0

  repository = aws_ecr_repository.ecr[0].name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Rule 1 - Keep the newest image tagged with production, expire others",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["production"],
                "countType": "imageCountMoreThan",
                "countNumber": 1
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 2,
            "description": "Rule 2 - Keep the newest image tagged with staging, expire others",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["staging"],
                "countType": "imageCountMoreThan",
                "countNumber": 1
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 3,
            "description": "Rule 3 - Expire images older than 14 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 14
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 4,
            "description": "Rule 4 - Get all images with any tag that is older than 60 days and mark it as expired, unless the image is one of the tagged in the previous rules",
            "selection": {
                "tagStatus": "any",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 60
            },
            "action": {
                "type": "expire"
            }
        }

    ]
}
EOF
}


################################################################################
# Repository Policy
################################################################################
data "aws_iam_policy_document" "ecr" {
  count = var.policy_allow_lambda && var.repo_policy == null ? 1 : 0
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:lambda:${var.region}:${var.account_id}:function:*",
      ]
    }
    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
    ]
  }
}

resource "aws_ecr_repository_policy" "ecr" {
  count = var.policy_allow_lambda || var.repo_policy != null ? 1 : 0

  repository = aws_ecr_repository.ecr[0].name
  policy     = var.repo_policy != null ? var.repo_policy : data.aws_iam_policy_document.ecr[0].json
}
