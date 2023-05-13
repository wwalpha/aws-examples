# ----------------------------------------------------------------------------------------------
# AWS VPC
# ----------------------------------------------------------------------------------------------
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                   = "${var.prefix}-vpc"
  cidr                   = var.vpc_cidr_block
  azs                    = var.availability_zones
  public_subnets         = var.public_subnets_cidr_block
  private_subnets        = var.private_subnets_cidr_block
  enable_dns_hostnames   = true
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
}
