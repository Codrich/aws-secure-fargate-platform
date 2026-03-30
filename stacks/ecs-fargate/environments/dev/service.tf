resource "aws_ecs_service" "app" {
  name            = "dev-app-svc"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.service_desired_count
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = data.terraform_remote_state.platform.outputs.alb_target_group_arn
    container_name   = "app"
    container_port   = var.container_port
  }

  network_configuration {
    subnets          = local.private_subnet_ids
    security_groups  = [aws_security_group.ecs_service.id]
    assign_public_ip = false
  }

  depends_on = [
    aws_iam_role_policy_attachment.task_execution_policy
  ]
}
