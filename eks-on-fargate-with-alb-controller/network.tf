# ----------------------------------------------------------------------------------------------
# VPC
# ----------------------------------------------------------------------------------------------
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "${var.prefix}-vpc"
  cidr                 = local.vpc_cidr_block
  azs                  = local.availability_zones
  public_subnets       = local.subnets_cidr_block_public
  private_subnets      = local.subnets_cidr_block_private
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_support   = true
  enable_dns_hostnames = true
}
