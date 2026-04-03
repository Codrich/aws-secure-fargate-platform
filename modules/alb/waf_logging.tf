resource "aws_cloudwatch_log_group" "waf_logs" {
  name              = "/aws/wafv2/${var.name_prefix}-logs"
  retention_in_days = 30
}

resource "aws_wafv2_web_acl_logging_configuration" "main" {
  resource_arn = aws_wafv2_web_acl.main.arn
  log_destination_configs = [
    aws_cloudwatch_log_group.waf_logs.arn
  ]
}