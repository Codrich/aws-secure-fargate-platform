resource "aws_acm_certificate" "dev" {
  domain_name       = var.dev_domain_name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "dev" {
  certificate_arn = aws_acm_certificate.dev.arn
}