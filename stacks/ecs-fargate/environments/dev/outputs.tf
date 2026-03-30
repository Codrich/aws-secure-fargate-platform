output "ecs_cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.ecs.name
}

output "alb_url" {
  value = "http://${data.terraform_remote_state.platform.outputs.alb_dns_name}"
}
