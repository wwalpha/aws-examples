# ----------------------------------------------------------------------------------------------
# Transit Gateway VPC Attachment
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  transit_gateway_id                              = var.transit_gateway_id
  vpc_id                                          = var.vpc_id
  subnet_ids                                      = var.subnet_ids
  dns_support                                     = var.dns_support
  appliance_mode_support                          = var.appliance_mode_support
  transit_gateway_default_route_table_association = var.transit_gateway_default_route_table_association
  transit_gateway_default_route_table_propagation = var.transit_gateway_default_route_table_propagation

  tags = merge(
    {
      Name = format(
        "%s-tgw-attachment",
        var.prefix,
      )
    },
    var.transit_gateway_vpc_attachment_tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table" "this" {
  transit_gateway_id = var.transit_gateway_id

  tags = merge(
    {
      Name = format(
        "%s-tgw-rt",
        var.prefix,
      )
    },
    var.transit_gateway_route_table_tags
  )
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "this" {
  destination_cidr_block         = var.transit_gateway_route_destination_cidr_block
  blackhole                      = false
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table Association
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table_association" "this" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table Propagation
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id
}
