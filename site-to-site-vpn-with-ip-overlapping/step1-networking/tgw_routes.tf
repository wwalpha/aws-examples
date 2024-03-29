# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table with Relay EU
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table" "relay_eu" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  tags = {
    Name = "${var.prefix}-tgw-RelayEU"
  }
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table Association with Relay EU
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table_association" "relay_eu" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.relay_eu.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.relay_eu.id
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route with Relay EU to Transit Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "relay_eu_to_tgw" {
  destination_cidr_block         = module.aws_app_vpc.vpc_cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.app.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.relay_eu.id
}


# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table with Relay US
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table" "relay_us" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  tags = {
    Name = "${var.prefix}-tgw-RelayUS"
  }
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table Association with Relay US
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table_association" "relay_us" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.relay_us.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.relay_us.id
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route with Relay US to Transit Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "relay_us_to_tgw" {
  destination_cidr_block         = module.aws_app_vpc.vpc_cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.app.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.relay_us.id
}


# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table with AWS App
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table" "aws_app" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  tags = {
    Name = "${var.prefix}-tgw-AWSApp"
  }
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table Association with AWS App
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table_association" "aws_app" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.app.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.aws_app.id
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route with Transit Gateway to Relay EU
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "tgw_to_relay_eu" {
  destination_cidr_block         = module.relay_vpc_for_eu.vpc_cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.relay_eu.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.aws_app.id
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route with Transit Gateway to Relay US
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "tgw_to_relay_us" {
  destination_cidr_block         = module.relay_vpc_for_us.vpc_cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.relay_us.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.aws_app.id
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route with Transit Gateway to Relay JP
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "tgw_to_relay_jp" {
  destination_cidr_block         = module.relay_vpc_for_jp.vpc_cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.relay_jp.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.aws_app.id
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table with Relay JP
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table" "relay_jp" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  tags = {
    Name = "${var.prefix}-tgw-RelayJP"
  }
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table Association with Relay JP
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table_association" "relay_jp" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.relay_jp.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.relay_jp.id
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route with Relay JP to Transit Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "relay_jp_to_tgw" {
  destination_cidr_block         = module.aws_app_vpc.vpc_cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.app.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.relay_jp.id
}
