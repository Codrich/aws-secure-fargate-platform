# --- SNS Topic for alarm notifications ---
resource "aws_sns_topic" "ecs_alarms" {
  name = "dev-ecs-alarms"
}

# --- ALB 5XX Errors ---
# Threshold: 5 errors in 1 minute
# Why: In dev, any sustained 5XX spike indicates a real issue.
# 5 errors/min filters out transient blips while catching real failures fast.
resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "dev-alb-5xx-errors"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 5
  alarm_description   = "ALB is returning 5XX errors - ECS tasks may be unhealthy"
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = data.terraform_remote_state.platform.outputs.alb_https_listener_arn
  }

  alarm_actions = [aws_sns_topic.ecs_alarms.arn]
  ok_actions    = [aws_sns_topic.ecs_alarms.arn]
}

# --- ECS CPU Utilization ---
# Threshold: 70% average over 5 minutes
# Why: Fargate tasks are capped at 256 CPU units in this config.
# 70% sustained means the service is near capacity and autoscaling
# should have already triggered. If it hasn't, something is wrong.
resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  alarm_name          = "dev-ecs-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "ECS service CPU above 70% for 3 consecutive minutes"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ClusterName = aws_ecs_cluster.this.name
    ServiceName = aws_ecs_service.app.name
  }

  alarm_actions = [aws_sns_topic.ecs_alarms.arn]
  ok_actions    = [aws_sns_topic.ecs_alarms.arn]
}

# --- ECS Running Task Count ---
# Threshold: drops below 1
# Why: If desired = 1 and running = 0, the service is completely down.
# This catches crashes that autoscaling hasn't recovered yet.
resource "aws_cloudwatch_metric_alarm" "ecs_no_running_tasks" {
  alarm_name          = "dev-ecs-no-running-tasks"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "RunningTaskCount"
  namespace           = "ECS/ContainerInsights"
  period              = 60
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "ECS service has no running tasks - service is down"
  treat_missing_data  = "breaching"

  dimensions = {
    ClusterName = aws_ecs_cluster.this.name
    ServiceName = aws_ecs_service.app.name
  }

  alarm_actions = [aws_sns_topic.ecs_alarms.arn]
  ok_actions    = [aws_sns_topic.ecs_alarms.arn]
}