[
      {
        "name": "jenkins",
        "image": "${jenkins_image}",
        "cpu": 0,
        "portMappings": [
          {
            "containerPort": 8080,
            "hostPort": 80,
            "protocol": "tcp"
          },
          {
            "containerPort": 50000,
            "hostPort": 50000,
            "protocol": "tcp"
          }
        ],
        "essential": true,
        "secrets": [
          {
            "name": "ACCESS_KEY",
            "valueFrom": "/${app_environment}/access_key"
          },
          {
            "name": "SECRET_KEY",
            "valueFrom": "/${app_environment}/secret_key"
          },
          {
            "name": "JENKINS_URL",
            "valueFrom" : "/${app_environment}/jenkins_url"
          },
          {
            "name": "FARGATE_SECURITY_GROUP",
            "valueFrom" : "/${app_environment}/fargate_security_group"
          },
          {
            "name": "ADMIN_PASSWORD",
            "valueFrom" : "/${app_environment}/admin_password"
          }
        ],
        "environment": [
          {
            "name": "JENKINS_CLUSTER",
            "value" : "${cluster_arn}"
          },
          {
            "name": "FARGATE_SUBNET",
            "value": "subnet-8bc567f1"
          }
        ],
        "mountPoints": [
          {
            "sourceVolume": "jenkins",
            "containerPath": "/var/jenkins_home"
          },
          {
            "sourceVolume": "docker_bin",
            "containerPath": "/usr/bin/docker"
          },
          {
            "sourceVolume": "docker_run",
            "containerPath": "/var/run/docker"
          },
          {
            "sourceVolume": "docker_sock",
            "containerPath": "/var/run/docker.sock"
          }
        ],
        "volumesFrom": []
      }
    ]
