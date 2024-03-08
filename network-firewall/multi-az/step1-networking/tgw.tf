# ----------------------------------------------------------------------------------------------
# Transit Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway" "this" {
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  multicast_support               = "disable"
  vpn_ecmp_support                = "disable"
  dns_support                     = "enable"
  transit_gateway_cidr_blocks     = local.cidr_block_tgw

  tags = {
    Name = "${var.prefix}-tgw"
  }
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway VPC Attachment - DMZ
# ----------------------------------------------------------------------------------------------
module "dmz_vpc_attachment" {
  source = "./tgw-attachment"

  prefix                                          = var.prefix
  transit_gateway_id                              = aws_ec2_transit_gateway.this.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  transit_gateway_route_destination_cidr_block    = local.vpc_cidr_block_app
  vpc_id                                          = aws_vpc.dmz.id
  subnet_ids                                      = aws_subnet.dmz_intra.*.id

  transit_gateway_vpc_attachment_tags = {
    Name = "${var.prefix}-dmz"
  }
  transit_gateway_route_table_tags = {
    Name = "${var.prefix}-dmz-rt"
  }
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway VPC Attachment - APP
# ----------------------------------------------------------------------------------------------
# module "app_vpc_attachment" {
#   source = "./tgw-attachment"

#   prefix                                          = var.prefix
#   transit_gateway_id                              = aws_ec2_transit_gateway.this.id
#   transit_gateway_default_route_table_association = false
#   transit_gateway_default_route_table_propagation = false
#   transit_gateway_route_destination_cidr_block    = "0.0.0.0/0"
#   vpc_id                                          = module.app_vpc.vpc_id
#   subnet_ids                                      = module.app_vpc.private_subnets

#   transit_gateway_vpc_attachment_tags = {
#     Name = "${var.prefix}-app"
#   }
#   transit_gateway_route_table_tags = {
#     Name = "${var.prefix}-app-rt"
#   }
# }

# ----------------------------------------------------------------------------------------------
# Transit Gateway VPC Attachment - App VPC
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_app" {
  transit_gateway_id                              = aws_ec2_transit_gateway.this.id
  vpc_id                                          = module.app_vpc.vpc_id
  subnet_ids                                      = module.app_vpc.private_subnets
  dns_support                                     = "enable"
  appliance_mode_support                          = "disable"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = {
    Name = format(
      "%s-tgw-attachment",
      "${var.prefix}-app"
    )
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table - App VPC
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table" "vpc_app" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  tags = {
    Name = "${var.prefix}-app-tgw-rt"
  }
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "app_to_dmz" {
  destination_cidr_block         = "0.0.0.0/0"
  blackhole                      = false
  transit_gateway_attachment_id  = module.dmz_vpc_attachment.transit_gateway_vpc_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpc_app.id
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table Association
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table_association" "vpc_app" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_app.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpc_app.id
}

# # ----------------------------------------------------------------------------------------------
# # Transit Gateway Route Table Propagation
# # ----------------------------------------------------------------------------------------------
# resource "aws_ec2_transit_gateway_route_table_propagation" "vpc_app" {
#   transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_app.id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpc_app.id
# }
