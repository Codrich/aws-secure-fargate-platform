resource "aws_ecs_service" "app" {
  name            = "dev-app-svc"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = local.private_subnet_ids
    security_groups = [aws_security_group.ecs_service.id]
    assign_public_ip = false
  }

  depends_on = [
    aws_iam_role_policy_attachment.task_execution_policy
  ]
}
