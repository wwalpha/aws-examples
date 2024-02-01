# ----------------------------------------------------------------------------------------------
# AWS Provider
# ----------------------------------------------------------------------------------------------
provider "aws" {}

terraform {
  backend "local" {
    path = "./tfstate/terraform.tfstate"
  }
}

module "networking" {
  source = "./step1-networking"
}

module "app" {
  source = "./step2-app"

  vpc_id          = module.networking.vpc_id
  private_subnets = module.networking.private_subnets
}
