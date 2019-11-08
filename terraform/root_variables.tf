variable "default_aws_region" {
  default = "eu-west-1"
}

variable "tag_prefix" {
  default = "jenkins"
}

variable "workspace_to_environment_map" {
  type = "map"

  //Maps the Terraform workspace to the AWS environment.
  default = {
    dev  = "dev"
    test = "test"
    prod = "prod"
  }
}
