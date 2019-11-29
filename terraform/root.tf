data "aws_s3_bucket_object" "secrets" {
  bucket = "tdr-secrets"
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
    bucket = "tdr-terraform-state-jenkins"
    key = "jenkins-terraform-state"
    region = "eu-west-2"
    encrypt = true
    dynamodb_table = "tdr-terraform-state-lock-jenkins"
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
  load_balancer_url = module.jenkins.load_balancer_url
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
  service_name = "jenkins-${local.environment}"
  role = "arn:aws:iam::328920706552:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
  ecs_private_subnet = module.ecs_network.ecs_private_subnet
  ecs_public_subnet = module.ecs_network.ecs_public_subnet
  ecs_vpc = module.ecs_network.ecs_vpc
  ecs_vpc_cidr = module.ecs_network.ecs_vpc_cidr
  elastic_ip_address = module.ecs_network.elastic_ip_address
  ecs_vpc_cidr_block = module.ecs_network.ecs_vpc_cidr_block
  account_id = module.caller.account_id
}
