# ----------------------------------------------------------------------------------------------
# Transit Gateway VPC Attachment Accept - Onpremise
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "onpremise" {
  transit_gateway_attachment_id = var.transit_gateway_attachment_id_onpremise

  tags = {
    Name = format("%s-tgw-attachment", var.prefix)
  }
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway VPC Attachment Accept - Workload App1
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "workload_app1" {
  transit_gateway_attachment_id = var.transit_gateway_attachment_id_workload_app1

  tags = {
    Name = format("%s-tgw-attachment", var.prefix)
  }
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway VPC Attachment Accept - Workload App2
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "workload_app2" {
  transit_gateway_attachment_id = var.transit_gateway_attachment_id_workload_app2

  tags = {
    Name = format("%s-tgw-attachment", var.prefix)
  }
}
