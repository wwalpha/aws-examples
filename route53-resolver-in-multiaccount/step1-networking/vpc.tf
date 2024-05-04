# ----------------------------------------------------------------------------------------------
# VPC
# ----------------------------------------------------------------------------------------------
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name               = "${var.prefix}-vpc"
  cidr               = var.vpc_cidr_block
  azs                = var.availability_zones
  private_subnets    = var.subnets_cidr_block_public
  public_subnets     = var.subnets_cidr_block_private
  enable_nat_gateway = true
}
