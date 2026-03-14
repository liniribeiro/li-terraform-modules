output "lb_name" {
  description = "Name of the Load Balancer"
  value       = try(aws_lb.this[0].name, null)
}

output "lb_dns_name" {
  description = "DNS name of the Load Balancer"
  value       = try(aws_lb.this[0].dns_name, null)
}

output "lb_arn" {
  description = "ARN that identifies the Load Balancer"
  value       = try(aws_lb.this[0].arn, null)
}

output "lb_sg_name" {
  description = "Name of the Load Balancer Security Group"
  value       = try(aws_security_group.lb_sg[0].name, null)
}

output "lb_sg_arn" {
  description = "ARN that identifies the Load Balancer Security Group"
  value       = try(aws_security_group.lb_sg[0].arn, null)
}
output "lb_sg_id" {
  description = "ID that identifies the Load Balancer Security Group"
  value       = try(aws_security_group.lb_sg[0].id, null)
}

output "service_target_group_id" {
  description = "ID that identifies the LB target group"
  value       = try(aws_lb_target_group.service[0].id, null)
}

output "service_target_group_arn" {
  description = "ARN that identifies the LB target group"
  value       = try(aws_lb_target_group.service[0].arn, null)
}

output "service_target_group_name" {
  description = "Name of the LB target group"
  value       = try(aws_lb_target_group.service[0].name, null)
}

output "service_target_group_port" {
  description = "Port of the LB target group"
  value       = try(aws_lb_target_group.service[0].port, null)
}

output "aws_lb_listener_arn" {
  description = "Load Balancer listener Arn"
  value       = try(aws_lb_listener.https[0].arn, null)
}
