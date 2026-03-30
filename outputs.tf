output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}

# ❌ REMOVED (ASG no longer exists)
# output "app_asg_name" {
#   value = module.compute.asg_name
# }

output "alarm_topic_arn" {
  value = module.observability.alarm_topic_arn
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "ops_dashboard_name" {
  value = module.observability.dashboard_name
}