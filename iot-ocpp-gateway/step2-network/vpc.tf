# ----------------------------------------------------------------------------------------------
# VPC
# ----------------------------------------------------------------------------------------------
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "${var.prefix}-vpc"
  cidr                 = local.vpc_cidr_block
  azs                  = local.availability_zones
  public_subnets       = local.public_subnets_cidr_block
  private_subnets      = local.private_subnets_cidr_block
  enable_dns_hostnames = true
  enable_nat_gateway   = true
}
