resource "aws_security_group" "lb" {
  name        = "${var.app_name}-load-balancer-security-group"
  description = "Controls access to the TDR application load balancer"
  vpc_id      = var.ecs_vpc

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
  var.common_tags,
  map("Name", "${var.app_name}-load-balancer-security-group-${var.environment}")
  )
}


resource "aws_security_group" "ecs_tasks" {
  name        = "${var.environment}-ecs-tasks-security-group"
  description = "Allow outbound access only"
  vpc_id      = "vpc-acbd21c4"

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 50000
    protocol = "tcp"
    to_port = 50000
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
  var.common_tags,
  map(
  "Name", "${var.environment}-ecs-task-security-group"
  )
  )
}