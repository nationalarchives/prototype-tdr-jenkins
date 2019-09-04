resource "aws_alb" "main" {
  name            = "tdr-jenkins-load-balancer-${var.environment}"
  subnets         = var.ecs_public_subnet
  security_groups = [aws_security_group.lb.id]

  tags = merge(
  var.common_tags,
  map("Name", "${var.app_name}-loadbalancer")
  )
}

resource "random_string" "alb_prefix" {
  length  = 4
  upper   = false
  special = false
}

resource "aws_alb_target_group" "jenkins" {
  name        = "jenkins-target-group-${random_string.alb_prefix.result}-${var.environment}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.ecs_vpc

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }

  tags = merge(
  var.common_tags,
  map("Name", "${var.app_name}-target-group")
  )
}

resource "aws_alb_target_group" "jenkins-slave" {
  name        = "jenkins-slave-group-${random_string.alb_prefix.result}-${var.environment}"
  port        = 50000
  protocol    = "HTTP"
  vpc_id      = var.ecs_vpc

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }

  tags = merge(
  var.common_tags,
  map("Name", "${var.app_name}-target-group")
  )
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "jenkins" {
  load_balancer_arn = aws_alb.main.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.jenkins.id
    type             = "forward"
  }
}

resource "aws_alb_listener" "jenkins" {
  load_balancer_arn = aws_alb.main.id
  port              = "50000"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.jenkins-slave.id
    type             = "forward"
  }
}