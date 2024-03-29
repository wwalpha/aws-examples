# ----------------------------------------------------------------------------------------------
# AWS Transit Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway" "this" {
  description                     = "example"
  default_route_table_propagation = "disable"
  default_route_table_association = "disable"
  tags = {
    Name = "${var.prefix}-tgw"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Transit Gateway VPC Attachment for Relay EU VPC
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "relay_eu" {
  subnet_ids         = [module.relay_vpc_for_eu.public_subnets[0]]
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = module.relay_vpc_for_eu.vpc_id
}

# ----------------------------------------------------------------------------------------------
# AWS Transit Gateway VPC Attachment for Relay US VPC
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "relay_us" {
  subnet_ids         = [module.relay_vpc_for_us.public_subnets[0]]
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = module.relay_vpc_for_us.vpc_id
}

# ----------------------------------------------------------------------------------------------
# AWS Transit Gateway VPC Attachment for Relay JP VPC
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "relay_jp" {
  subnet_ids         = [module.relay_vpc_for_jp.public_subnets[0]]
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = module.relay_vpc_for_jp.vpc_id
}

# ----------------------------------------------------------------------------------------------
# AWS Transit Gateway VPC Attachment for Application VPC
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "app" {
  subnet_ids         = [module.aws_app_vpc.public_subnets[0]]
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = module.aws_app_vpc.vpc_id
}
