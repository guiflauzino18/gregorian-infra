#LOAD BALANCING
resource "aws_lb" "this" {
  name = var.name
  internal = var.internal
  load_balancer_type = var.load-balancer-type
  security_groups = var.lb-security-groups
  subnets = var.subnets
  enable_deletion_protection = var.enable-deletion-protection
  tags = var.tags
}

#TARGET GROUP
resource "aws_lb_target_group" "this" {
  name = "tg-${var.name}"
  port = var.lb-target-port
  protocol = var.lb-protocol
  target_type = var.lb-target-type
  vpc_id = var.vpc-id
  tags = var.tags
  depends_on = [aws_lb.this]
}

#LISTENER
resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port = var.lb-listener-port
  protocol = var.lb-listener-protocol
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

data "aws_instances" "this" {
  #Pega todas as instancias criadas pelo autoscaling
  filter {
    name = "tag:Resource"
    values = ["ec2template"]
  }
}

#ATTACH INSTANCE TO TARGET GROUP
resource "aws_lb_target_group_attachment" "this" {
  count = length(data.aws_instances.this.ids)
  target_group_arn = aws_lb_target_group.this.arn
  target_id = data.aws_instances.this.ids[count.index]
}

#LAUNCH TEMPLATE
resource "aws_launch_template" "this" {
  name = var.name
  image_id = var.image-id
  instance_type = var.as-instance-type
  key_name = var.key-name
  user_data = var.user-data
  tags = merge({"Resource" = "ec2template"}, var.tags)

  network_interfaces {
    security_groups = var.as-vpc-sg-ids
  }
}

# AUTOSCALING
resource "aws_autoscaling_group" "this" {
  name = var.name
  max_size = var.max-size
  min_size = var.min-size
  desired_capacity = var.desired-capacity
  health_check_grace_period = 300
  health_check_type = var.asg-health-check-type
  vpc_zone_identifier = var.subnets
  target_group_arns = [ aws_lb_target_group.this.arn ]

  launch_template {
    id = aws_launch_template.this.id
    version = aws_launch_template.this.latest_version
  }
}

resource "aws_autoscaling_policy" "scale-up" {
  name = "${var.name}-autoscaling-up"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = "1" #incrementa instancia em 1
  cooldown = "300"
  policy_type = "SimpleScaling"
}

resource "aws_autoscaling_policy" "scale-down" {
  name = "${var.name}-autoscalling-down"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1" # decrementa instancia em 1 
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}