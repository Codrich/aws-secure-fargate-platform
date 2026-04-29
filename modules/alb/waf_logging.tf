# Dedicated KMS key for WAF logs encryption
resource "aws_kms_key" "waf_logs" {
  description             = "KMS key for WAFv2 CloudWatch logs - ${var.name_prefix}"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow CloudWatch Logs"
        Effect = "Allow"
        Principal = {
          Service = "logs.us-east-1.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name = "${var.name_prefix}-waf-logs-kms"
  }
}

resource "aws_kms_alias" "waf_logs" {
  name          = "alias/waf-logs-${var.name_prefix}"
  target_key_id = aws_kms_key.waf_logs.key_id
}

# CloudWatch Log Group for WAFv2 logs
resource "aws_cloudwatch_log_group" "waf_logs" {
  name              = "aws-waf-logs-${var.name_prefix}"
  retention_in_days = 365
  kms_key_id        = aws_kms_key.waf_logs.arn
  depends_on        = [aws_kms_key.waf_logs]

  tags = {
    Name = "${var.name_prefix}-waf-logs"
  }
}

# WAFv2 Logging Configuration
resource "aws_wafv2_web_acl_logging_configuration" "main" {
  resource_arn            = aws_wafv2_web_acl.alb_waf.arn
  log_destination_configs = [aws_cloudwatch_log_group.waf_logs.arn]
}