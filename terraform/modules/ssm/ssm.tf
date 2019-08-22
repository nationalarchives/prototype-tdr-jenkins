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
  value       = "http://3.9.165.101"

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

resource "aws_ssm_parameter" "admin_password" {
  name        = "/${var.environment}/admin_password"
  description = "The admin password for jenkins"
  type        = "String"
  value       = var.secrets.admin_password

  tags = {
    environment = var.environment
  }
}
