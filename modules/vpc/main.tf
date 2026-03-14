locals {
  private_hosted_zone_name = var.private_root_dns != null ? "${var.env}.${var.private_root_dns}" : module.const.env_dns

  tags = merge(
    {
      "Environment"  = format("%s", var.env)
      "CostResource" = format("%s", var.app_name)
    },
    var.tags,
  )
}

module "const" {
  source = "../constants"
  env    = var.env
  account_id = var.account_id
  region = var.region
}

module "name" {
  source         = "../naming"
  env            = var.env
  app_name       = var.app_name
  app_short_name = var.app_short_name
}

################################################################################
# Data
################################################################################
data "aws_vpc" "selected" {
  id = var.vpc_id
}

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


data "aws_acm_certificate" "wildcard" {
  domain = "*.liniatech.com"
}

################################################################################
# DNS
################################################################################
data "aws_route53_zone" "this" {
  name         = local.private_hosted_zone_name
  private_zone = true
}

resource "aws_route53_record" "this" {
  count = var.create ? 1 : 0
  name  = var.app_name
  type  = "CNAME"

  records = [
    aws_lb.this[0].dns_name,
  ]

  zone_id = data.aws_route53_zone.this.zone_id
  ttl     = "60"
}


################################################################################
# SG
################################################################################
resource "aws_security_group" "lb_sg" {
  count  = var.create ? 1 : 0
  name   = "${module.name.env_app_name}-2"
  vpc_id = data.aws_vpc.selected.id
  tags   = local.tags

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [
      data.aws_vpc.selected.cidr_block
    ]

    ipv6_cidr_blocks = [data.aws_vpc.selected.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

################################################################################
# ALB
################################################################################

resource "aws_lb" "this" {
  count              = var.create ? 1 : 0
  name               = module.name.env_app_name
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg[0].id]
  subnets            = [for subnet in data.aws_subnet.private : subnet.id]
  tags               = local.tags

  enable_deletion_protection = true

  # access_logs {
  #   bucket  = data.aws_s3_bucket.logs.bucket
  #   prefix  = "${var.app_name}-lb"
  #   enabled = true
  # }

}


resource "aws_lb_listener" "https" {
  count = var.create ? 1 : 0

  load_balancer_arn = aws_lb.this[0].arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = data.aws_acm_certificate.wildcard.arn
  tags              = local.tags

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service[0].arn
  }
}


resource "aws_lb_target_group" "service" {
  count       = var.create ? 1 : 0
  name        = module.name.env_app_name
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  target_type = "ip"
  vpc_id      = data.aws_vpc.selected.id
  tags        = local.tags

  health_check {
    path                = var.target_group_health_config.path
    port                = var.target_group_health_config.port
    healthy_threshold   = var.target_group_health_config.healthy_threshold
    unhealthy_threshold = var.target_group_health_config.unhealthy_threshold
    timeout             = var.target_group_health_config.timeout
    interval            = var.target_group_health_config.interval
    matcher             = var.target_group_health_config.matcher
  }
}
