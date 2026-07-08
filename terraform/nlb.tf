############################################
# Target Group
############################################

resource "aws_lb_target_group" "web_target_group" {

  name     = "${var.project_name}-tg"
  port     = var.target_port
  protocol = "TCP"

  vpc_id = data.aws_vpc.default.id

  health_check {

    enabled = true

    path = "/"

    protocol = "HTTP"

    matcher = "200"

    interval = 30

    timeout = 5

    healthy_threshold = 2

    unhealthy_threshold = 2
  }

  tags = {
    Name = "Web Target Group"
  }
}

############################################
# Network Load Balancer
############################################

resource "aws_lb" "network_load_balancer" {

  name = "${var.project_name}-nlb"

  internal = false

  load_balancer_type = "network"

  subnets = data.aws_subnets.default.ids

  enable_deletion_protection = false

  tags = {
    Name = "FinTrust NLB"
  }
}

############################################
# HTTP Listener
############################################

resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.network_load_balancer.arn

  port = var.listener_port

  protocol = "TCP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.web_target_group.arn

  }
}

