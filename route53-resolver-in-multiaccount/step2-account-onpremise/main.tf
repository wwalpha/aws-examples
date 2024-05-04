# ----------------------------------------------------------------------------------------------
# RAM Resource Share Accepter - Transit Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_share_accepter" "tgw" {
  share_arn = var.ram_invitation_arn_transit_gateway
}

# ----------------------------------------------------------------------------------------------
# Networking
# ----------------------------------------------------------------------------------------------
module "networking" {
  depends_on                 = [aws_ram_resource_share_accepter.tgw]
  source                     = "../commons-networking"
  prefix                     = "${var.prefix}-onpremise"
  vpc_cidr_block             = var.vpc_cidr_block
  subnets_cidr_block_public  = var.subnets_cidr_block_public
  subnets_cidr_block_private = var.subnets_cidr_block_private
  availability_zones         = var.availability_zones
  transit_gateway_id         = var.transit_gateway_id
}

# ----------------------------------------------------------------------------------------------
# Application
# ----------------------------------------------------------------------------------------------
# module "application" {
#   depends_on             = [module.networking]
#   source                 = "./app"
#   prefix                 = "${var.prefix}-onpremise"
#   vpc_id                 = module.networking.vpc_id
#   vpc_public_subnet_ids  = module.networking.vpc_public_subnet_ids
#   vpc_private_subnet_ids = module.networking.vpc_private_subnet_ids
# }
