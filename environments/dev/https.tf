# ACM certificate for dev.mertmart.com (DNS validation via Bluehost)
resource "aws_acm_certificate" "dev" {
  domain_name       = var.dev_domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# HTTPS listener on 443 (will succeed AFTER cert validation is complete)
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.app.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.dev.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs.arn
  }

  depends_on = [
    aws_acm_certificate_validation.dev
  ]
}

# HTTP listener redirects to HTTPS
resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      protocol    = "HTTPS"
      port        = "443"
      status_code = "HTTP_301"
    }
  }
}


# This waits for you to add the DNS validation CNAME in Bluehost.
resource "aws_acm_certificate_validation" "dev" {
  certificate_arn = aws_acm_certificate.dev.arn
}
