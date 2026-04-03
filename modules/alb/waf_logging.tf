# CloudWatch Log Group for WAFv2 logs
resource "aws_cloudwatch_log_group" "waf_logs" {
  name              = "/aws/wafv2/${var.name_prefix}-logs"
  retention_in_days = 365                    # ← Fixes CKV_AWS_338 (at least 1 year)

  # Encrypt logs with KMS (required for CKV_AWS_158)
  kms_key_id = aws_kms_key.waf_logs.arn

  tags = {
    Name = "${var.name_prefix}-waf-logs"
  }
}

# Dedicated KMS key for WAF logs encryption
resource "aws_kms_key" "waf_logs" {
  description             = "KMS key for WAFv2 CloudWatch logs - ${var.name_prefix}"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = {
    Name = "${var.name_prefix}-waf-logs-kms"
  }
}

resource "aws_kms_alias" "waf_logs" {
  name          = "alias/waf-logs-${var.name_prefix}"
  target_key_id = aws_kms_key.waf_logs.key_id
}

# WAFv2 Logging Configuration
resource "aws_wafv2_web_acl_logging_configuration" "main" {
  resource_arn            = aws_wafv2_web_acl.main.arn          # Correct attribute
  log_destination_configs = [aws_cloudwatch_log_group.waf_logs.arn]
}