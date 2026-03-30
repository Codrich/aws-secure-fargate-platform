data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

locals {
  user_data = <<-EOF
    #!/bin/bash
    set -e
    dnf update -y
    dnf install -y nginx
    systemctl enable nginx
    systemctl start nginx
    echo "OK: ${var.name_prefix}" > /usr/share/nginx/html/index.html
  EOF
}

resource "aws_launch_template" "app" {
  name_prefix   = "${var.name_prefix}-lt-"
  image_id      = data.aws_ami.al2023.id
  instance_type = "t2.micro"

  iam_instance_profile {
    name = var.ec2_instance_profile_name
  }

  vpc_security_group_ids = [var.app_sg_id]
  user_data              = base64encode(local.user_data)

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required" # IMDSv2 enforced
    http_put_response_hop_limit = 2
  }
}

# resource "aws_autoscaling_group" "app" {
#   name                = "${var.name_prefix}-asg-app"
#   min_size         = 0
#   max_size         = 1
#   desired_capacity = 1
#   capacity_rebalance = false
#   vpc_zone_identifier = var.private_subnet_ids
#
#   launch_template {
#     id      = aws_launch_template.app.id
#     version = "$Latest"
#   }
#   target_group_arns = var.target_group_arns
#
#   health_check_type         = "EC2"
#   health_check_grace_period = 60
#
#   tag {
#     key                 = "Name"
#     value               = "${var.name_prefix}-app"
#     propagate_at_launch = true
#   }
# }

# resource "aws_cloudwatch_metric_alarm" "cpu_high" {
#   alarm_name          = "${var.name_prefix}-cpu-high"
#   comparison_operator = "GreaterThanThreshold"
#   evaluation_periods  = 2
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = 300
#   statistic           = "Average"
#   threshold           = 70
#
#   alarm_actions = [var.alarm_topic_arn]
#
#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.app.name
#   }
# }