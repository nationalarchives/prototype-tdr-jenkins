resource "aws_alb" "main" {
  name            = "tdr-jenkins-load-balancer-${var.environment}"
  subnets         = var.ecs_public_subnet
  load_balancer_type = "network"
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
  protocol    = "TCP"
  vpc_id      = var.ecs_vpc
  stickiness {
    enabled = false
    type = "lb_cookie"
  }

  tags = merge(
  var.common_tags,
  map("Name", "${var.app_name}-target-group")
  )
}

resource "aws_alb_target_group" "jenkins_api" {
  name        = "jenkins-slave-group-${random_string.alb_prefix.result}-${var.environment}"
  port        = 50000
  protocol    = "TCP"
  vpc_id      = var.ecs_vpc
  stickiness {
    enabled = false
    type = "lb_cookie"
  }

  tags = merge(
  var.common_tags,
  map("Name", "${var.app_name}-target-group")
  )
}

resource "aws_alb_listener" "jenkins_50000" {
  load_balancer_arn = aws_alb.main.id
  port              = "50000"
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_alb_target_group.jenkins_api.id
    type             = "forward"
  }
}

resource "aws_alb_listener" "jenkins" {
  load_balancer_arn = aws_alb.main.id
  port              = "80"
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_alb_target_group.jenkins.id
    type             = "forward"
  }
}