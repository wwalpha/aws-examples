# ----------------------------------------------------------------------------------------------
# Route53 Hosted Zone - Private
# ----------------------------------------------------------------------------------------------
resource "aws_route53_zone" "this" {
  name          = var.cloud_domain_name
  force_destroy = true

  vpc {
    vpc_id = module.networking.vpc_id
  }

  lifecycle {
    ignore_changes = [vpc]
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route53 Resolver Endpoint - Central Inbound Resolver Endpoint
# ----------------------------------------------------------------------------------------------
resource "aws_route53_resolver_endpoint" "inbound" {
  name      = "${var.prefix}-inbound"
  direction = "INBOUND"
  protocols = ["Do53"]

  security_group_ids = [
    module.inbound_endpoint_sg.security_group_id
  ]

  dynamic "ip_address" {
    for_each = var.route53_resolver_inbound_endpoint_ip_addresses
    content {
      subnet_id = module.networking.vpc_private_subnet_ids[ip_address.key]
      ip        = ip_address.value
    }
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route53 Resolver Endpoint - Central Outbound Resolver Endpoint
# ----------------------------------------------------------------------------------------------
resource "aws_route53_resolver_endpoint" "outbound" {
  name      = "${var.prefix}-outbound"
  direction = "OUTBOUND"
  protocols = ["Do53"]

  security_group_ids = [
    module.outbound_endpoint_sg.security_group_id
  ]

  dynamic "ip_address" {
    for_each = var.route53_resolver_outbound_endpoint_ip_addresses
    content {
      subnet_id = module.networking.vpc_private_subnet_ids[ip_address.key]
      ip        = ip_address.value
    }
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route53 Resolver Rule(System) - amazonaws.com
# ----------------------------------------------------------------------------------------------
resource "aws_route53_resolver_rule" "system" {
  domain_name = "amazonaws.com"
  name        = "system"
  rule_type   = "SYSTEM"
}

# ----------------------------------------------------------------------------------------------
# AWS Route53 Resolver Rule(Forward) - master.local
# ----------------------------------------------------------------------------------------------
resource "aws_route53_resolver_rule" "forward_master_local" {
  domain_name          = "master.local"
  name                 = "onpremise"
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.outbound.id

  target_ip {
    ip = var.onpremise_dns_server_ip
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route53 Resolver Rule(Forward) - master.aws
# ----------------------------------------------------------------------------------------------
resource "aws_route53_resolver_rule" "forward_master_aws" {
  domain_name          = "master.aws"
  name                 = "awscloud"
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.outbound.id
}
