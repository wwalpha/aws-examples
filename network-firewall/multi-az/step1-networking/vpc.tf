# ----------------------------------------------------------------------------------------------
# VPC - DMZ
# ----------------------------------------------------------------------------------------------
resource "aws_vpc" "dmz" {
  cidr_block = local.vpc_cidr_block_dmz

  tags = {
    Name = "${var.prefix}-dmz-vpc"
  }
}

# ----------------------------------------------------------------------------------------------
# VPC - App
# ----------------------------------------------------------------------------------------------
module "app_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "${var.prefix}-app-vpc"
  cidr                 = local.vpc_cidr_block_app
  azs                  = local.availability_zones
  private_subnets      = local.cidr_block_app_subnets_private
  enable_dns_hostnames = true
  enable_nat_gateway   = false
}
