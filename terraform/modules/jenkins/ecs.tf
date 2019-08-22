resource "aws_ecs_cluster" "jenkins_cluster" {
  name = "jenkins-${var.environment}"

  tags = merge(
  var.common_tags,
  map("Name", var.tag_name)
  )
}

data "template_file" "jenkins_template" {
  template = file("./modules/jenkins/templates/jenkins.json.tpl")

  vars = {
    jenkins_image = "${var.task_image}:${var.environment}"
    app_environment = var.environment
    role = var.role
    cluster_arn = aws_ecs_cluster.jenkins_cluster.arn
  }
}

resource "aws_ecs_task_definition" "jenkins_task" {
  family                   = "${var.container_name}-${var.environment}"
  execution_role_arn       = var.role
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = var.cpu
  memory                   = var.memory
  container_definitions    = data.template_file.jenkins_template.rendered
  task_role_arn            = var.role

  volume {
    name      = "jenkins"
    host_path = "/var/lib/docker/volumes/ecs-jenkins"
  }

  volume {
    name = "docker_bin"
    host_path = "/usr/bin/docker"
  }

  volume {
    name = "docker_run"
    host_path = "/var/run/docker"
  }

  volume {
    name = "docker_sock"
    host_path = "/var/run/docker.sock"
  }


  tags = merge(
  var.common_tags,
  map(
  "Name", "${var.container_name}-task-definition-${var.environment}",
  )
  )
}

resource "aws_ecs_service" "jenkins" {
  name                              = "${var.service_name}-service-${var.environment}"
  cluster                           = aws_ecs_cluster.jenkins_cluster.id
  task_definition                   = aws_ecs_task_definition.jenkins_task.arn
  desired_count                     = 1
  launch_type                       = "EC2"
}
