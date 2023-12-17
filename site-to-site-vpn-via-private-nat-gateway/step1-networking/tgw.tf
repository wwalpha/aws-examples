# ----------------------------------------------------------------------------------------------
# AWS Transit Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway" "this" {
  description = "example"
  tags = {
    Name = "${var.prefix}-tgw"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Transit Gateway VPC Attachment for Relay VPC A
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "relay_eu" {
  subnet_ids         = [module.relay_vpc_for_eu.public_subnets[0]]
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = module.relay_vpc_for_eu.vpc_id
}

# ----------------------------------------------------------------------------------------------
# AWS Transit Gateway VPC Attachment for Relay VPC B
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "relay_us" {
  subnet_ids         = [module.relay_vpc_for_us.public_subnets[0]]
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = module.relay_vpc_for_us.vpc_id
}

# ----------------------------------------------------------------------------------------------
# AWS Transit Gateway VPC Attachment for Application VPC
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "app" {
  subnet_ids         = [module.aws_app_vpc.public_subnets[0]]
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = module.aws_app_vpc.vpc_id
}
