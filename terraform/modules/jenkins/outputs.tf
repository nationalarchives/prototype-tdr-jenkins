output "fargate_security_group" {
  value = aws_security_group.ecs_tasks.id
}

output "load_balancer_url" {
  value = "http://${aws_alb.main.dns_name}"
}

output "fargate_role" {
  value = aws_iam_role.jenkins_fargate_role.arn
}