# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table - Central DNS
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table" "central_dns" {
  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment_accepter.onpremise,
    aws_ec2_transit_gateway_vpc_attachment_accepter.workload_app1,
    aws_ec2_transit_gateway_vpc_attachment_accepter.workload_app2
  ]

  transit_gateway_id = var.transit_gateway_id

  tags = {
    Name = format("%s-central-dns-tgw-rt", var.prefix)
  }
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route - CentralDNS to Onpremise
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "centraldns_to_onpremise" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.central_dns.id
  transit_gateway_attachment_id  = var.transit_gateway_attachment_id_onpremise
  destination_cidr_block         = var.vpc_cidr_block_onpremise
  blackhole                      = false
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route - CentralDNS to Workload App1
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "centraldns_to_workload_app1" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.central_dns.id
  transit_gateway_attachment_id  = var.transit_gateway_attachment_id_workload_app1
  destination_cidr_block         = var.vpc_cidr_block_app1
  blackhole                      = false
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route - CentralDNS to Workload App2
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "centraldns_to_workload_app2" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.central_dns.id
  transit_gateway_attachment_id  = var.transit_gateway_attachment_id_workload_app2
  destination_cidr_block         = var.vpc_cidr_block_app2
  blackhole                      = false
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table Association - CentralDNS
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table_association" "central_dns" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.central_dns.id
  transit_gateway_attachment_id  = var.transit_gateway_attachment_id_central_dns
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table - Onpremise
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table" "onpremise" {
  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment_accepter.onpremise,
    aws_ec2_transit_gateway_vpc_attachment_accepter.workload_app1,
    aws_ec2_transit_gateway_vpc_attachment_accepter.workload_app2
  ]

  transit_gateway_id = var.transit_gateway_id

  tags = {
    Name = format("%s-onpremise-tgw-rt", var.prefix)
  }
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route - Onpremise to CentralDNS
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "onpremise_to_centraldns" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.onpremise.id
  transit_gateway_attachment_id  = var.transit_gateway_attachment_id_central_dns
  destination_cidr_block         = var.vpc_cidr_block_central_dns
  blackhole                      = false
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table Association - Onpremise
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table_association" "onpremise" {
  depends_on                     = [aws_ec2_transit_gateway_vpc_attachment_accepter.onpremise]
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.onpremise.id
  transit_gateway_attachment_id  = var.transit_gateway_attachment_id_onpremise
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table - Workload App1
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table" "workload_app1" {
  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment_accepter.onpremise,
    aws_ec2_transit_gateway_vpc_attachment_accepter.workload_app1,
    aws_ec2_transit_gateway_vpc_attachment_accepter.workload_app2
  ]

  transit_gateway_id = var.transit_gateway_id

  tags = {
    Name = format("%s-workload-app1-tgw-rt", var.prefix)
  }
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route - Workload App1 to CentralDNS
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "worload_app1_to_centraldns" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.workload_app1.id
  transit_gateway_attachment_id  = var.transit_gateway_attachment_id_central_dns
  destination_cidr_block         = var.vpc_cidr_block_central_dns
  blackhole                      = false
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table Association - Workload App1
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table_association" "workload_app1" {
  depends_on                     = [aws_ec2_transit_gateway_vpc_attachment_accepter.workload_app1]
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.workload_app1.id
  transit_gateway_attachment_id  = var.transit_gateway_attachment_id_workload_app1
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table - Workload App2
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table" "workload_app2" {
  transit_gateway_id = var.transit_gateway_id

  tags = {
    Name = format("%s-workload-app2-tgw-rt", var.prefix)
  }
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route - Workload App2 to CentralDNS
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route" "worload_app2_to_centraldns" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.workload_app2.id
  transit_gateway_attachment_id  = var.transit_gateway_attachment_id_central_dns
  destination_cidr_block         = var.vpc_cidr_block_central_dns
  blackhole                      = false
}

# ----------------------------------------------------------------------------------------------
# Transit Gateway Route Table Association - Workload App1
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_transit_gateway_route_table_association" "workload_app2" {
  depends_on                     = [aws_ec2_transit_gateway_vpc_attachment_accepter.workload_app2]
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.workload_app2.id
  transit_gateway_attachment_id  = var.transit_gateway_attachment_id_workload_app2
}
