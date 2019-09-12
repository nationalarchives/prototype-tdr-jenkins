resource "aws_security_group" "ec2" {
  name        = "${var.app_name}-ec2-security-group"
  description = "Controls access to the TDR application EC2 instance"
  vpc_id      = var.ecs_vpc

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["85.115.53.202/32"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 50000
    to_port     = 50000
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
  vpc_id      = var.ecs_vpc

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
  var.common_tags,
  map(
  "Name", "${var.environment}-ecs-task-security-group"
  )
  )
}

