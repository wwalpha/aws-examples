# ----------------------------------------------------------------------------------------------
# Client VPN Endpoint
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_client_vpn_endpoint" "this" {
  server_certificate_arn        = var.client_vpn_server_certificate_arn
  client_cidr_block             = "172.168.0.0/16"
  split_tunnel                  = true
  session_timeout_hours         = 8
  disconnect_on_session_timeout = true

  authentication_options {
    type              = "federated-authentication"
    saml_provider_arn = var.saml_provider_arn
  }

  connection_log_options {
    enabled = false
  }

  tags = {
    Name = "${var.prefix}-endpoint"
  }
}

# ----------------------------------------------------------------------------------------------
# Client VPN Network Association
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_client_vpn_network_association" "this" {
  count                  = length(module.vpc_clientvpn.private_subnets)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  subnet_id              = module.vpc_clientvpn.private_subnets[count.index]
}

# ----------------------------------------------------------------------------------------------
# Client VPN Authorization Rule - VPC01
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_client_vpn_authorization_rule" "vpc01" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  target_network_cidr    = local.vpc_cidr_block_01
  access_group_id        = var.vpn_group_id_01
}

# ----------------------------------------------------------------------------------------------
# Client VPN Authorization Rule - VPC01
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_client_vpn_authorization_rule" "vpc02" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  target_network_cidr    = local.vpc_cidr_block_02
  access_group_id        = var.vpn_group_id_02
}

# ----------------------------------------------------------------------------------------------
# Client VPN Route - VPC01
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_client_vpn_route" "vpc01" {
  count                  = length(module.vpc_01.private_subnets)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  destination_cidr_block = module.vpc_01.private_subnets_cidr_blocks[count.index]
  target_vpc_subnet_id   = aws_ec2_client_vpn_network_association.this[count.index].subnet_id
}

# ----------------------------------------------------------------------------------------------
# Client VPN Route - VPC01
# ----------------------------------------------------------------------------------------------
resource "aws_ec2_client_vpn_route" "vpc02" {
  count                  = length(module.vpc_02.private_subnets)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  destination_cidr_block = module.vpc_02.private_subnets_cidr_blocks[count.index]
  target_vpc_subnet_id   = aws_ec2_client_vpn_network_association.this[count.index].subnet_id
}
