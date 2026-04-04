resource "aws_wafv2_web_acl" "alb_waf" {
  name        = "${var.name_prefix}-waf"
  description = "WAF for ALB"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  # Rule 1: AWS Common Rule Set
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.name_prefix}-common-rules"
      sampled_requests_enabled   = true
    }
  }

  # Rule 2: Known Bad Inputs (Log4j / Log4Shell) - Fixes CKV_AWS_192 + CKV2_AWS_76
  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.name_prefix}-known-bad-inputs"
      sampled_requests_enabled   = true
    }
  }

  # Top-level visibility config for the Web ACL itself
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.name_prefix}-waf"
    sampled_requests_enabled   = true
  }
}

# Associate WAF with the ALB
resource "aws_wafv2_web_acl_association" "alb_assoc" {
  resource_arn = aws_lb.this.arn
  web_acl_arn  = aws_wafv2_web_acl.alb_waf.arn
}