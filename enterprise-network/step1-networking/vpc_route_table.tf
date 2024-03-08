# ----------------------------------------------------------------------------------------------
# AWS Route Table - Worload Private Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "workload_private" {
  vpc_id = aws_vpc.workload.id

  # 0.0.0.0/0 > Transit Gateway
  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.this.id
  }

  tags = {
    Name = "${aws_vpc.workload.tags.Name}-private-rt"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Worload Private Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "workload_private" {
  count          = length(local.subnets_cidr_block_workload_private)
  subnet_id      = element(aws_subnet.workload_private[*].id, count.index)
  route_table_id = aws_route_table.workload_private.id
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table - Egress Public Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "egress_public" {
  count  = length(local.subnets_cidr_block_egress_public)
  vpc_id = aws_vpc.egress.id

  # 0.0.0.0/0 > Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.egress.id
  }

  # 10.40.0.0/16 > Transit Gateway
  route {
    cidr_block         = local.vpc_cidr_block_workload
    transit_gateway_id = aws_ec2_transit_gateway.this.id
  }

  tags = {
    Name = format(
      "${aws_vpc.egress.tags.Name}-public-rt-%s",
      local.az_suffix[count.index],
    )
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Egress Public Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "egress_public" {
  count          = length(local.subnets_cidr_block_egress_tgw)
  subnet_id      = element(aws_subnet.egress_public[*].id, count.index)
  route_table_id = element(aws_route_table.egress_public[*].id, count.index)
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table - Egress TGW Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "egress_tgw" {
  count  = length(local.subnets_cidr_block_egress_tgw)
  vpc_id = aws_vpc.egress.id

  # 0.0.0.0/0 > NAT Gateway
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.egress_nat[*].id, count.index)
  }

  tags = {
    Name = format(
      "${aws_vpc.egress.tags.Name}-tgw-rt-%s",
      local.az_suffix[count.index],
    )
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Egress TGW Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "egress_tgw" {
  count          = length(local.subnets_cidr_block_egress_tgw)
  subnet_id      = element(aws_subnet.egress_tgw[*].id, count.index)
  route_table_id = element(aws_route_table.egress_tgw[*].id, count.index)
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table - Ingress Public Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "ingress_public" {
  vpc_id = aws_vpc.ingress.id

  # 0.0.0.0/0 > Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ingress.id
  }

  # 10.0.0.0/8 > Transit Gateway
  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.this.id
  }

  tags = {
    Name = "${aws_vpc.ingress.tags.Name}-public-rt"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Ingress Public Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "ingress_public" {
  count          = length(aws_subnet.ingress_public[*].id)
  subnet_id      = element(aws_subnet.ingress_public[*].id, count.index)
  route_table_id = aws_route_table.ingress_public.id
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table - Ingress TGW Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table" "ingress_tgw" {
  vpc_id = aws_vpc.ingress.id

  # 10.0.0.0/8 > Transit Gateway
  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.this.id
  }

  tags = {
    Name = "${aws_vpc.ingress.tags.Name}-tgw-rt"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route Table Association - Ingress TGW Subnets
# ----------------------------------------------------------------------------------------------
resource "aws_route_table_association" "ingress_tgw" {
  count          = length(aws_subnet.ingress_tgw[*].id)
  subnet_id      = element(aws_subnet.ingress_tgw[*].id, count.index)
  route_table_id = aws_route_table.ingress_tgw.id
}

# # ----------------------------------------------------------------------------------------------
# # AWS Route Table - DMZ Firewall Subnets
# # ----------------------------------------------------------------------------------------------
# resource "aws_route_table" "dmz_firewall" {
#   depends_on = [aws_nat_gateway.this, module.dmz_vpc_attachment]
#   count      = length(local.cidr_block_dmz_subnets_firewall)

#   vpc_id = aws_vpc.dmz.id

#   # 10.0.0.0/8 > Transit Gateway
#   route {
#     cidr_block         = local.cidr_block_aws_cloud
#     transit_gateway_id = aws_ec2_transit_gateway.this.id
#   }

#   # 0.0.0.0/0 > NAT Gateway
#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.this[count.index].id
#   }

#   tags = {
#     Name = format(
#       "${aws_vpc.dmz.tags.Name}-dmz-firewall-rt-%s",
#       local.az_suffix[count.index],
#     )
#   }
# }

# # ----------------------------------------------------------------------------------------------
# # AWS Route Table Association - DMZ Firewall Subnets
# # ----------------------------------------------------------------------------------------------
# resource "aws_route_table_association" "dmz_firewall" {
#   count = length(local.cidr_block_dmz_subnets_firewall)

#   subnet_id      = element(aws_subnet.dmz_firewall[*].id, count.index)
#   route_table_id = element(aws_route_table.dmz_firewall[*].id, count.index)
# }

# # ----------------------------------------------------------------------------------------------
# # AWS Route Table - DMZ Intra Subnets
# # ----------------------------------------------------------------------------------------------
# resource "aws_route_table" "dmz_intra" {
#   depends_on = [aws_networkfirewall_firewall.this]
#   count      = length(local.cidr_block_dmz_subnets_intra)

#   vpc_id = aws_vpc.dmz.id

#   # 0.0.0.0/0 > Firewall Endpoint
#   route {
#     cidr_block      = "0.0.0.0/0"
#     vpc_endpoint_id = local.firewall_endpoints[count.index]
#   }

#   tags = {
#     Name = format(
#       "${aws_vpc.dmz.tags.Name}-dmz-intra-rt-%s",
#       local.az_suffix[count.index],
#     )
#   }
# }

# # ----------------------------------------------------------------------------------------------
# # AWS Route Table Association - DMZ Intra Subnets
# # ----------------------------------------------------------------------------------------------
# resource "aws_route_table_association" "dmz_intra" {
#   count = length(local.cidr_block_dmz_subnets_intra)

#   subnet_id      = element(aws_subnet.dmz_intra[*].id, count.index)
#   route_table_id = element(aws_route_table.dmz_intra[*].id, count.index)
# }

# # ----------------------------------------------------------------------------------------------
# # AWS Route - APP VPC to Transit Gateway
# # ----------------------------------------------------------------------------------------------
# resource "aws_route" "app_to_dmz" {
#   for_each               = toset(module.app_vpc.private_route_table_ids)
#   route_table_id         = each.value
#   destination_cidr_block = "0.0.0.0/0"
#   transit_gateway_id     = aws_ec2_transit_gateway.this.id

#   lifecycle {
#     create_before_destroy = true
#   }
# }
