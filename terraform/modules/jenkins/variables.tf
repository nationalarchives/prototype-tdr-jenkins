variable "common_tags" {
  description = "The tags which all resources must use"
}

variable "environment" {
  description = "The environment"
}

variable "tag_name" {
  type    = string
  default = "tdr-ecs"
}

variable "tag_service" {
  type    = string
  default = "tdr-ecs"
}

variable "aws_region" {
  description = "The AWS region"
  default     = "eu-west-2"
}

variable "role" {
  description = "Role arn for the ecsTaskExecutionRole"
}

variable "cpu" {
  description = "CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "256"
}

variable "memory" {
  description = "Memory to provision (in MiB)"
  default     = "512"
}

variable "task_image" {
  description = "The docker image to run virus checks against the files"
  default = "docker.io/nationalarchives/jenkins"
}

variable "task_name" {
  description = "The name of the virus check task"
  default = "jenkins"
}

variable "container_name" {
  description = "The name of the container"
  default = "jenkins"
}

variable "service_name" {
  description = "The name of the service"
}