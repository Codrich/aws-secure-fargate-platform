# --- CloudWatch Logs (for ECS task logs) ---
resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/dev/app"
  retention_in_days = 14
}

# --- ECS Cluster ---
resource "aws_ecs_cluster" "this" {
  name = "dev-ecs-fargate"
}
