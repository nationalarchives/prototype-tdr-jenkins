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

variable "cpu" {
  description = "CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "256"
}

variable "memory" {
  description = "Memory to provision (in MiB)"
  default     = "1024"
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

variable "ecs_private_subnet" {
  description = "The private subnet for jenkins"
}

variable "ecs_vpc" {
  description = "The VPC for jenkins"
}

variable "health_check_path" {
  default = "/login"
}

variable "app_name" {
  description = "Name of the hosted application"
  type        = string
  default     = "tdr-jenkins"
}


variable "ecs_public_subnet" {
  description = "The public subnet for the application"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = "8080"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}

variable "ecs_vpc_cidr" {}

variable "elastic_ip_address" {}

variable "ecs_vpc_cidr_block" {}

variable "account_id" {}

variable "role" {}