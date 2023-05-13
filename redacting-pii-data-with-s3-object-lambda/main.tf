# ----------------------------------------------------------------------------------------------
# AWS Provider
# ----------------------------------------------------------------------------------------------
provider "aws" {}

terraform {
  backend "local" {
    path = "./tfstate/terraform.tfstate"
  }
}

module "storage" {
  source = "./storage"
  prefix = local.prefix
}

module "security" {
  source = "./security"
  prefix = local.prefix
}

module "app" {
  source              = "./app"
  prefix              = local.prefix
  iam_role_arn_lambda = module.security.iam_role_arn_lambda
  s3_access_point_arn = module.storage.s3_ascess_point_arn
  s3_bucket_name      = module.storage.s3_bucket_name
}


#terraform import aws_s3control_object_lambda_access_point.this 334678299258:aokadoapii
