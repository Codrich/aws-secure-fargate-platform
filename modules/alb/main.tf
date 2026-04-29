resource "aws_lb" "this" {
  name                       = "${var.name_prefix}-alb"
  load_balancer_type         = "application"
  subnets                    = var.public_subnet_ids
  security_groups            = [var.alb_sg_id]

  # === Checkov fixes ===
  enable_deletion_protection = true     # CKV_AWS_150
  drop_invalid_header_fields = true     # CKV_AWS_131

  # Access logging using the variable you already have
  access_logs {
    bucket  = var.log_bucket_name      # ← Use this instead of direct resource reference
    prefix  = "alb-logs"
    enabled = true
  }

  tags = {
    Name = "${var.name_prefix}-alb"
  }
}

resource "aws_lb_target_group" "app" {
  name        = "${var.name_prefix}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }
}

# HTTP → Redirect to HTTPS
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# HTTPS Listener (Secure) - Already had good ssl_policy
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"   # Good - satisfies CKV2_AWS_74 + CKV_AWS_103
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}