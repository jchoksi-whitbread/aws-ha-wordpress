resource "aws_launch_configuration" "hawordpress" {
  name_prefix   = "hawordpress-lc-"
  image_id      = "ami-5ae4f83c"
  instance_type = "t2.micro"
  user_data = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.hawordpress.name} > /etc/ecs/ecs.config"
  iam_instance_profile = "${aws_iam_instance_profile.hawordpress.name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "ecs_cluster_scale_in" {
  name                   = "ecs-cluster-scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.hawordpress.name}"
}

resource "aws_autoscaling_policy" "ecs_cluster_scale_out" {
  name                   = "ecs-cluster-scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.hawordpress.name}"
}

resource "aws_autoscaling_group" "hawordpress" {
  availability_zones        = ["${aws_default_subnet.default_az1.availability_zone}","${aws_default_subnet.default_az2.availability_zone}","${aws_default_subnet.default_az3.availability_zone}"]
  name                      = "hawordpress"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  launch_configuration      = "${aws_launch_configuration.hawordpress.name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_attachment" "hawordpress" {
  autoscaling_group_name = "${aws_autoscaling_group.hawordpress.id}"
  alb_target_group_arn   = "${aws_alb_target_group.hawordpress.arn}"
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 5
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.hawordpress.name}/${aws_ecs_service.hawordpress.name}"
  role_arn           = "${aws_iam_role.hawordpress2.arn}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_service_scale_in" {
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 60
  metric_aggregation_type = "Maximum"
  name                    = "ecs-service-scale-down"
  resource_id             = "service/${aws_ecs_cluster.hawordpress.name}/${aws_ecs_service.hawordpress.name}"
  scalable_dimension      = "ecs:service:DesiredCount"
  service_namespace       = "ecs"

  step_adjustment {
    metric_interval_upper_bound = 0
    scaling_adjustment          = -1
  }

  depends_on = ["aws_appautoscaling_target.ecs_target"]
}

resource "aws_appautoscaling_policy" "ecs_service_scale_out" {
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 60
  metric_aggregation_type = "Maximum"
  name                    = "ecs-service-scale-up"
  resource_id             = "service/${aws_ecs_cluster.hawordpress.name}/${aws_ecs_service.hawordpress.name}"
  scalable_dimension      = "ecs:service:DesiredCount"
  service_namespace       = "ecs"

  step_adjustment {
    metric_interval_lower_bound = 0
    scaling_adjustment          = 1
  }

  depends_on = ["aws_appautoscaling_target.ecs_target"]
}

resource "aws_cloudwatch_metric_alarm" "ecs_service_scale_in" {
  alarm_name          = "ecs-service-scale-in"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "25"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.hawordpress.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_appautoscaling_policy.ecs_service_scale_in.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "ecs_service_scale_out" {
  alarm_name          = "ecs-service-scale-out"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "75"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.hawordpress.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_appautoscaling_policy.ecs_service_scale_out.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "ecs_cluster_scale_in" {
  alarm_name          = "ecs-cluster-scale-in"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "25"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.hawordpress.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.ecs_cluster_scale_in.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "ecs_cluster_scale_out" {
  alarm_name          = "ecs-cluster-scale-out"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "75"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.hawordpress.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.ecs_cluster_scale_out.arn}"]
}