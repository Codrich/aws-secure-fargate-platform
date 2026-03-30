# ECS Service Autoscaling (Target Tracking on CPU)

resource "aws_appautoscaling_target" "ecs" {
  max_capacity       = var.service_max_capacity
  min_capacity       = var.service_min_capacity
  service_namespace  = "ecs"
  scalable_dimension = "ecs:service:DesiredCount"

  # Required format: service/<cluster-name>/<service-name>
  resource_id = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.app.name}"
}

resource "aws_appautoscaling_policy" "cpu_target_tracking" {
  name               = "cpu-target-tracking"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = var.cpu_target_utilization
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}
