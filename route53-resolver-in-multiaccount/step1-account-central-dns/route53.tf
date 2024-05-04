# ----------------------------------------------------------------------------------------------
# Route53 Hosted Zone - Private
# ----------------------------------------------------------------------------------------------
resource "aws_route53_zone" "this" {
  name          = var.domain_name
  force_destroy = true

  vpc {
    vpc_id = module.networking.vpc_id
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route53 Resolver Endpoint - Central Inbound Resolver Endpoint
# ----------------------------------------------------------------------------------------------
resource "aws_route53_resolver_endpoint" "inbound" {
  name      = "${var.prefix}-inbound"
  direction = "INBOUND"

  security_group_ids = [
    module.inbound_endpoint_sg.security_group_id
  ]

  ip_address {
    subnet_id = module.networking.vpc_private_subnet_ids[0]
    ip        = local.route53_resolver_inbound_endpoint_address1
  }

  ip_address {
    subnet_id = module.networking.vpc_private_subnet_ids[1]
    ip        = local.route53_resolver_inbound_endpoint_address2
  }

  protocols = ["Do53"]
}

# ----------------------------------------------------------------------------------------------
# AWS Route53 Resolver Endpoint - Central Outbound Resolver Endpoint
# ----------------------------------------------------------------------------------------------
resource "aws_route53_resolver_endpoint" "outbound" {
  name      = "${var.prefix}-outbound"
  direction = "OUTBOUND"

  security_group_ids = [
    module.outbound_endpoint_sg.security_group_id
  ]

  ip_address {
    subnet_id = module.networking.vpc_private_subnet_ids[0]
    ip        = local.route53_resolver_outbound_endpoint_address1
  }

  ip_address {
    subnet_id = module.networking.vpc_private_subnet_ids[1]
    ip        = local.route53_resolver_outbound_endpoint_address2
  }

  protocols = ["Do53"]
}

# ----------------------------------------------------------------------------------------------
# AWS Route53 Resolver Rule(System) - amazonaws.com
# ----------------------------------------------------------------------------------------------
resource "aws_route53_resolver_rule" "system" {
  domain_name = "amazonaws.com"
  rule_type   = "SYSTEM"
}

# ----------------------------------------------------------------------------------------------
# AWS Route53 Resolver Rule(Forward) - master.local
# ----------------------------------------------------------------------------------------------
resource "aws_route53_resolver_rule" "foward" {
  domain_name          = "master.local"
  name                 = "onpremise"
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.outbound.id

  target_ip {
    ip = local.route53_resolver_outbound_endpoint_address1
  }

  target_ip {
    ip = local.route53_resolver_outbound_endpoint_address2
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Route53 Resolver Rule Association(Forward) - master.local
# ----------------------------------------------------------------------------------------------
resource "aws_route53_resolver_rule_association" "foward" {
  resolver_rule_id = aws_route53_resolver_rule.foward.id
  vpc_id           = module.networking.vpc_id
}
