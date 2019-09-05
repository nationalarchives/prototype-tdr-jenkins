data "aws_ami" "ecs_ami" {
  owners = ["591542846629"]
  name_regex       = "^amzn2-ami-ecs-hvm-2.0.\\d{8}-x86_64-ebs"
  most_recent = true
}

resource "aws_instance" "jenkins" {
  ami = data.aws_ami.ecs_ami.id
  instance_type = "t2.small"
  iam_instance_profile = aws_iam_instance_profile.jenkins_profile.name

  network_interface {
    network_interface_id = aws_network_interface.ec2_network_interface[0].id
    device_index = 0
  }
  key_name = "jenkins_key_pair"
  user_data = "#!/usr/bin/env bash\necho ECS_CLUSTER=${aws_ecs_cluster.jenkins_cluster.name} > /etc/ecs/ecs.config"
  tags = merge(
  var.common_tags,
  map(
  "Name", "${var.container_name}-task-definition-${var.environment}",
  )
  )
}

resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "jenkins_instance_profile_${var.environment}"
  role = aws_iam_role.jenkins_ec2_role.name
}

resource "aws_iam_role" "jenkins_ec2_role" {
  name = "jenkins_lambda_role_${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.jenkins_ec2_assume_role.json
  tags = merge(
  var.common_tags,
  map(
  "Name", "jenkins-lambda-iam-role-${var.environment}",
  )
  )
}

data "aws_iam_policy_document" "jenkins_ec2_assume_role" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "jenkins_ec2_policy" {
  name   = "jenkins_ec2_policy_${var.environment}"
  path   = "/"
  policy = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "invoke_api_attach" {
  role       = aws_iam_role.jenkins_ec2_role.name
  policy_arn = aws_iam_policy.jenkins_ec2_policy.arn
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    actions = [
      "ec2:DescribeTags",
      "ecs:CreateCluster",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:UpdateContainerInstancesState",
      "ecs:Submit*",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_network_interface" "ec2_network_interface" {
  count          = var.az_count
  subnet_id       = var.ecs_private_subnet[0]
  security_groups = [aws_security_group.ec2.id]
}
