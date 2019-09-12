resource "aws_ssm_parameter" "access_key" {
  name        = "/${var.environment}/access_key"
  description = "The access key"
  type        = "String"
  value       = var.secrets.access_key

  tags = {
    environment = var.environment
  }
}

resource "aws_ssm_parameter" "secret_key" {
  name        = "/${var.environment}/secret_key"
  description = "The access key"
  type        = "String"
  value       = var.secrets.secret_key

  tags = {
    environment = var.environment
  }
}

resource "aws_ssm_parameter" "jenkins_url" {
  name        = "/${var.environment}/jenkins_url"
  description = "The url for the jenkins server"
  type        = "String"
  value       = var.load_balancer_url

  tags = {
    environment = var.environment
  }
}

resource "aws_ssm_parameter" "fargate_security_group" {
  name        = "/${var.environment}/fargate_security_group"
  description = "The security group for the fargate jenkins slaves"
  type        = "String"
  value       = var.fargate_security_group

  tags = {
    environment = var.environment
  }
}

resource "aws_ssm_parameter" "github_client" {
  name        = "/${var.environment}/github/client"
  description = "The client id for the github auth integration"
  type        = "String"
  value       = var.secrets.github_client

  tags = {
    environment = var.environment
  }
}

resource "aws_ssm_parameter" "github_secret" {
  name        = "/${var.environment}/github/secret"
  description = "The client secret for the github auth integration"
  type        = "String"
  value       = var.secrets.github_secret

  tags = {
    environment = var.environment
  }
}
