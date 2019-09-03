data "aws_s3_bucket_object" "secrets" {
  bucket = "tna-secrets"
  key    = "${local.environment}/secrets.yml"
}

locals {
  #Ensure that developers' workspaces always default to 'dev'
  environment = lookup(var.workspace_to_environment_map, terraform.workspace, "dev")
  tag_prefix = var.tag_prefix
  aws_region = var.default_aws_region
  common_tags = map(
  "Environment", local.environment,
  "Owner", "TDR",
  "Terraform", true
  )
  secrets_file_content = data.aws_s3_bucket_object.secrets.body
  secrets = yamldecode(local.secrets_file_content)
}

terraform {
  backend "s3" {
    bucket = "tna-jenkins-terraform-state"
    key = "prototype-terraform-state"
    region = "eu-west-2"
    encrypt = true
    dynamodb_table = "tna-jenkins-terraform-statelock"
  }
}

provider "aws" {
  region = local.aws_region
}


module "ssm" {
  source = "./modules/ssm"
  environment = local.environment
  secrets = local.secrets
  fargate_security_group = module.jenkins.fargate_security_group
}

module "caller" {
  source = "./modules/caller"
}

module "ecs_network" {
  source = "./modules/network"
  common_tags = local.common_tags
  environment = local.environment
  app_name = "jenkins"
}

module "jenkins" {
  source = "./modules/jenkins"
  common_tags = local.common_tags
  environment = local.environment
  role = "arn:aws:iam::${module.caller.account_id}:role/ecsTaskExecutionRole"
  service_name = "jenkins-${local.environment}"
  ecs_private_subnet = module.ecs_network.ecs_private_subnet
  ecs_public_subnet = module.ecs_network.ecs_public_subnet
  ecs_vpc = module.ecs_network.ecs_vpc
  network_interface_id = module.ecs_network.ec2_network_interface
}