output "ecs_cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.ecs.name
}

output "alb_url" {
  value = "http://${data.terraform_remote_state.platform.outputs.alb_dns_name}"
}

output "app_secret_arn" {
  description = "ARN of the Secrets Manager secret"
  value       = aws_secretsmanager_secret.app.arn
}