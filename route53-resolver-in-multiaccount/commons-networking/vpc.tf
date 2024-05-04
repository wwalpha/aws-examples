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

# ----------------------------------------------------------------------------------------------
# AWS Route - Transit Gateway
# ----------------------------------------------------------------------------------------------
# resource "aws_route" "private" {
#   count                  = length(module.vpc.private_route_table_ids)
#   route_table_id         = module.vpc.private_route_table_ids[count.index]
#   destination_cidr_block = local.vpc_cidr_block_cloud
#   transit_gateway_id     = var.transit_gateway_id
# }
