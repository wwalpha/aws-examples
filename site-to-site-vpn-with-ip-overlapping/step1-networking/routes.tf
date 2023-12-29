# ----------------------------------------------------------------------------------------------
# Relay EU Route to AWS App via Transit Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_route" "relay_eu_to_tgw" {
  route_table_id         = module.relay_vpc_for_eu.public_route_table_ids[0]
  destination_cidr_block = module.aws_app_vpc.vpc_cidr_block
  transit_gateway_id     = aws_ec2_transit_gateway.this.id
}

# ----------------------------------------------------------------------------------------------
# Relay EU Route to Relay JP via VPC Peering
# ----------------------------------------------------------------------------------------------
# resource "aws_route" "relay_eu_to_relay_jp" {
#   route_table_id            = module.relay_vpc_for_eu.public_route_table_ids[0]
#   destination_cidr_block    = module.relay_vpc_for_jp.vpc_cidr_block
#   vpc_peering_connection_id = aws_vpc_peering_connection.relay_eu_peering_relay_jp.id
# }

# ----------------------------------------------------------------------------------------------
# Relay US Route to AWS App via Transit Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_route" "relay_us_to_tgw" {
  route_table_id         = module.relay_vpc_for_us.public_route_table_ids[0]
  destination_cidr_block = module.aws_app_vpc.vpc_cidr_block
  transit_gateway_id     = aws_ec2_transit_gateway.this.id
}

# ----------------------------------------------------------------------------------------------
# Relay US Route to Relay JP via VPC Peering
# ----------------------------------------------------------------------------------------------
# resource "aws_route" "relay_us_to_relay_jp" {
#   route_table_id            = module.relay_vpc_for_us.public_route_table_ids[0]
#   destination_cidr_block    = module.relay_vpc_for_jp.vpc_cidr_block
#   vpc_peering_connection_id = aws_vpc_peering_connection.relay_us_peering_relay_jp.id
# }

# ----------------------------------------------------------------------------------------------
# Relay JP Route to AWS App via Transit Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_route" "relay_jp_to_tgw" {
  route_table_id         = module.relay_vpc_for_jp.public_route_table_ids[0]
  destination_cidr_block = module.aws_app_vpc.vpc_cidr_block
  transit_gateway_id     = aws_ec2_transit_gateway.this.id
}

# ----------------------------------------------------------------------------------------------
# Relay JP Route to Relay EU via VPC Peering
# ----------------------------------------------------------------------------------------------
# resource "aws_route" "relay_jp_to_relay_eu" {
#   route_table_id            = module.relay_vpc_for_jp.public_route_table_ids[0]
#   destination_cidr_block    = module.relay_vpc_for_eu.vpc_cidr_block
#   vpc_peering_connection_id = aws_vpc_peering_connection.relay_eu_peering_relay_jp.id
# }

# ----------------------------------------------------------------------------------------------
# Relay JP Route to Relay US via VPC Peering
# ----------------------------------------------------------------------------------------------
# resource "aws_route" "relay_jp_to_relay_us" {
#   route_table_id            = module.relay_vpc_for_jp.public_route_table_ids[0]
#   destination_cidr_block    = module.relay_vpc_for_us.vpc_cidr_block
#   vpc_peering_connection_id = aws_vpc_peering_connection.relay_us_peering_relay_jp.id
# }

# ----------------------------------------------------------------------------------------------
# Transit Gateway to Relay US Route
# ----------------------------------------------------------------------------------------------
resource "aws_route" "tgw_to_relay_us" {
  route_table_id         = module.aws_app_vpc.public_route_table_ids[0]
  destination_cidr_block = module.relay_vpc_for_us.vpc_cidr_block
  transit_gateway_id     = aws_ec2_transit_gateway.this.id
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway to Relay EU Route
# ----------------------------------------------------------------------------------------------
resource "aws_route" "tgw_to_relay_eu" {
  route_table_id         = module.aws_app_vpc.public_route_table_ids[0]
  destination_cidr_block = module.relay_vpc_for_eu.vpc_cidr_block
  transit_gateway_id     = aws_ec2_transit_gateway.this.id
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway to Relay JP Route
# ----------------------------------------------------------------------------------------------
resource "aws_route" "tgw_to_relay_jp" {
  route_table_id         = module.aws_app_vpc.public_route_table_ids[0]
  destination_cidr_block = module.relay_vpc_for_jp.vpc_cidr_block
  transit_gateway_id     = aws_ec2_transit_gateway.this.id
}
