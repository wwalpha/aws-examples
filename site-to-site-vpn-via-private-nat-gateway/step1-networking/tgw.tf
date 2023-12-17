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
resource "aws_ec2_transit_gateway_vpc_attachment" "relay_a" {
  subnet_ids         = [module.aws_relay_vpc_for_a.public_subnets[0]]
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = module.aws_relay_vpc_for_a.vpc_id
}

# ----------------------------------------------------------------------------------------------
# AWS Transit Gateway VPC Attachment for Relay VPC B
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "relay_b" {
  subnet_ids         = [module.aws_relay_vpc_for_b.public_subnets[0]]
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = module.aws_relay_vpc_for_b.vpc_id
}

# ----------------------------------------------------------------------------------------------
# AWS Transit Gateway VPC Attachment for Application VPC
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "app" {
  subnet_ids         = [module.aws_app_vpc.public_subnets[0]]
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = module.aws_app_vpc.vpc_id
}
