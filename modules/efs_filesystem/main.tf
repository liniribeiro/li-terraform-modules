provider "aws" {
  region = var.region
}

locals {
  subnet_ids = [for subnet in data.aws_subnet.private : subnet.id]

  tags = merge(
    {
      "Environment" = format("%s", var.env)
      "Name"        = format("%s", var.name)
    },
    var.tags,
  )
}

################################################################################
# Data
################################################################################

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    Name = "${var.env}-private-*"
  }
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}


################################################################################
# EFS
################################################################################
resource "aws_efs_file_system" "this" {
  creation_token   = var.name
  performance_mode = var.performance_mode
  throughput_mode  = var.throughput_mode
  encrypted        = true
  tags             = local.tags
}


resource "aws_efs_mount_target" "this" {
  for_each = toset(local.subnet_ids)

  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = each.value
  security_groups = [var.default_vpc_sg]
}
