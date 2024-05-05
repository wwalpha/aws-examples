# ----------------------------------------------------------------------------------------------
# Networking
# ----------------------------------------------------------------------------------------------
module "networking" {
  source                     = "../commons-networking"
  prefix                     = "${var.prefix}-central-dns"
  vpc_cidr_block             = var.vpc_cidr_block
  subnets_cidr_block_public  = var.subnets_cidr_block_public
  subnets_cidr_block_private = var.subnets_cidr_block_private
  availability_zones         = var.availability_zones
  transit_gateway_id         = aws_ec2_transit_gateway.this.id
}

# ----------------------------------------------------------------------------------------------
# AWS Route - Transit Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_route" "tgw" {
  depends_on             = [module.networking]
  for_each               = toset(module.networking.vpc_private_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.vpc_cidr_block_cloud
  transit_gateway_id     = aws_ec2_transit_gateway.this.id
}
