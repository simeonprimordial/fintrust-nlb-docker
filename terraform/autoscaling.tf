############################################
# Auto Scaling Group
############################################

resource "aws_autoscaling_group" "web_asg" {

  name = "${var.project_name}-asg"

  desired_capacity = var.desired_capacity
  min_size         = var.min_size
  max_size         = var.max_size

  vpc_zone_identifier = data.aws_subnets.default.ids

  target_group_arns = [
    aws_lb_target_group.web_target_group.arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {

    id = aws_launch_template.web_launch_template.id

    version = "$Latest"

  }

  tag {
    key                 = "Name"
    value               = "Apache-Web-Server"
    propagate_at_launch = true
  }
}

############################################
# Target Tracking Scaling Policy
############################################

resource "aws_autoscaling_policy" "cpu_target_tracking" {

  name = "${var.project_name}-cpu-policy"

  autoscaling_group_name = aws_autoscaling_group.web_asg.name

  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {

    predefined_metric_specification {

      predefined_metric_type = "ASGAverageCPUUtilization"

    }

    target_value = 60.0

  }
}