resource "aws_sns_topic" "alarms" {
  name = "${var.name_prefix}-alarms"
}

resource "aws_cloudwatch_log_group" "vpc_flowlogs" {
  name              = "/aws/vpc/flowlogs/${var.name_prefix}"
  retention_in_days = 14
}

resource "aws_cloudwatch_dashboard" "ops" {
  dashboard_name = "${var.name_prefix}-ops-dashboard"

  dashboard_body = jsonencode({
    widgets = concat(

      # ✅ ONLY include ASG widgets IF asg_name exists
      var.asg_name != null ? [
        {
          type   = "metric"
          x      = 0
          y      = 0
          width  = 12
          height = 6
          properties = {
            title  = "ASG CPU Utilization (Average)"
            region = var.aws_region
            period = 300
            stat   = "Average"
            metrics = [
              ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", var.asg_name]
            ]
          }
        },
        {
          type   = "metric"
          x      = 12
          y      = 18
          width  = 12
          height = 6
          properties = {
            title  = "ASG Capacity (Desired / InService)"
            region = var.aws_region
            period = 60
            stat   = "Average"
            metrics = [
              ["AWS/AutoScaling", "GroupDesiredCapacity", "AutoScalingGroupName", var.asg_name],
              ["AWS/AutoScaling", "GroupInServiceInstances", "AutoScalingGroupName", var.asg_name]
            ]
          }
        }
      ] : [],

      # ✅ ALWAYS include ALB + core metrics
      [
        {
          type   = "metric"
          x      = 12
          y      = 0
          width  = 12
          height = 6
          properties = {
            title  = "ALB Request Count"
            region = var.aws_region
            period = 60
            stat   = "Sum"
            metrics = [
              ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", var.alb_arn_suffix]
            ]
          }
        },
        {
          type   = "metric"
          x      = 0
          y      = 6
          width  = 12
          height = 6
          properties = {
            title  = "ALB Target Response Time"
            region = var.aws_region
            period = 60
            stat   = "Average"
            metrics = [
              ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", var.alb_arn_suffix, "TargetGroup", var.target_group_arn_suffix]
            ]
          }
        },
        {
          type   = "metric"
          x      = 12
          y      = 6
          width  = 12
          height = 6
          properties = {
            title  = "ALB 5XX Errors (ELB + Target)"
            region = var.aws_region
            period = 60
            stat   = "Sum"
            metrics = [
              ["AWS/ApplicationELB", "HTTPCode_ELB_5XX_Count", "LoadBalancer", var.alb_arn_suffix],
              ["AWS/ApplicationELB", "HTTPCode_Target_5XX_Count", "LoadBalancer", var.alb_arn_suffix, "TargetGroup", var.target_group_arn_suffix]
            ]
          }
        },
        {
          type   = "metric"
          x      = 0
          y      = 18
          width  = 12
          height = 6
          properties = {
            title  = "ALB 4XX/5XX (Target + ELB)"
            region = var.aws_region
            period = 60
            stat   = "Sum"
            metrics = [
              ["AWS/ApplicationELB", "HTTPCode_ELB_4XX_Count", "LoadBalancer", var.alb_arn_suffix],
              ["AWS/ApplicationELB", "HTTPCode_ELB_5XX_Count", "LoadBalancer", var.alb_arn_suffix],
              ["AWS/ApplicationELB", "HTTPCode_Target_4XX_Count", "LoadBalancer", var.alb_arn_suffix, "TargetGroup", var.target_group_arn_suffix],
              ["AWS/ApplicationELB", "HTTPCode_Target_5XX_Count", "LoadBalancer", var.alb_arn_suffix, "TargetGroup", var.target_group_arn_suffix]
            ]
          }
        },
        {
          type   = "metric"
          x      = 0
          y      = 24
          width  = 24
          height = 6
          properties = {
            title  = "ALB Target Health (Healthy / Unhealthy)"
            region = var.aws_region
            period = 60
            stat   = "Average"
            metrics = [
              ["AWS/ApplicationELB", "HealthyHostCount", "LoadBalancer", var.alb_arn_suffix, "TargetGroup", var.target_group_arn_suffix],
              ["AWS/ApplicationELB", "UnHealthyHostCount", "LoadBalancer", var.alb_arn_suffix, "TargetGroup", var.target_group_arn_suffix]
            ]
          }
        },
        {
          type   = "alarm"
          x      = 0
          y      = 30
          width  = 24
          height = 6
          properties = {
            title = "Alarms (Dev)"
            alarms = [
              "arn:aws:cloudwatch:us-east-1:376129869231:alarm:aws-secure-vpc-terraform-dev-cpu-high"
            ]
          }
        }
      ]
    )
  })
}