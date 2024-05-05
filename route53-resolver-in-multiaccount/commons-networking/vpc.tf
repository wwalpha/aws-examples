# ----------------------------------------------------------------------------------------------
# VPC
# ----------------------------------------------------------------------------------------------
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "${var.prefix}-vpc"
  cidr                 = var.vpc_cidr_block
  azs                  = var.availability_zones
  public_subnets       = var.subnets_cidr_block_public
  private_subnets      = var.subnets_cidr_block_private
  enable_nat_gateway   = true
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# ----------------------------------------------------------------------------------------------
# AWS Route - Transit Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_route" "transit_gateway" {
  count                  = length(module.vpc.private_route_table_ids)
  route_table_id         = element(module.vpc.private_route_table_ids, count.index)
  destination_cidr_block = local.vpc_cidr_block_cloud
  transit_gateway_id     = var.transit_gateway_id
}
