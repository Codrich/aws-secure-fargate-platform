# ECS service SG
resource "aws_security_group" "ecs_service" {
  name        = "dev-ecs-service-sg"
  description = "Security group for ECS service"
  vpc_id      = local.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ✅ ALB -> ECS only (replaces the temp CIDR rule)
resource "aws_security_group_rule" "ecs_ingress_from_alb" {
  type                     = "ingress"
  security_group_id        = aws_security_group.ecs_service.id
  from_port                = var.container_port
  to_port                  = var.container_port
  protocol                 = "tcp"
  source_security_group_id = data.terraform_remote_state.platform.outputs.alb_security_group_id
}
