output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "alb_https_listener_arn" {
  value = module.alb.alb_arn_suffix
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "alb_target_group_arn" {
  value = module.alb.target_group_arn
}