resource "aws_iam_role" "jenkins_fargate_role" {
  name = "jenkins_fargate_role_${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.jenkins_fargate_assume_role.json
  tags = merge(
  var.common_tags,
  map(
  "Name", "jenkins-fargate-iam-role-${var.environment}",
  )
  )
}

data "aws_iam_policy_document" "jenkins_fargate_assume_role" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "jenkins_fargate_policy" {
  name   = "jenkins_fargate_policy_${var.environment}"
  path   = "/"
  policy = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "fargate_task_attach" {
  role       = aws_iam_role.jenkins_fargate_role.name
  policy_arn = aws_iam_policy.jenkins_fargate_policy.arn
}

data "aws_iam_policy_document" "fargate_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "*",
    ]
  }
}