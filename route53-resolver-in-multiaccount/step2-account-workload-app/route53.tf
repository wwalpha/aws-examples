# ----------------------------------------------------------------------------------------------
# Route53 Hosted Zone - Private
# ----------------------------------------------------------------------------------------------
resource "aws_route53_zone" "this" {
  depends_on    = [module.networking]
  name          = var.domain_name
  force_destroy = true

  vpc {
    vpc_id = module.networking.vpc_id
  }

  lifecycle {
    ignore_changes = [vpc]
  }
}

# ----------------------------------------------------------------------------------------------
# Route53 VPC Association Authorization
# ----------------------------------------------------------------------------------------------
resource "aws_route53_vpc_association_authorization" "this" {
  vpc_id  = var.vpc_id_central_dns
  zone_id = aws_route53_zone.this.id
}

# ----------------------------------------------------------------------------------------------
# Route53 Record - ALB
# ----------------------------------------------------------------------------------------------
resource "aws_route53_record" "alb" {
  allow_overwrite = true
  zone_id         = aws_route53_zone.this.zone_id
  name            = "alb.${aws_route53_zone.this.name}"
  type            = "A"

  alias {
    name                   = module.application.alb_dns_name
    zone_id                = module.application.alb_zone_id
    evaluate_target_health = true
  }
}

# ----------------------------------------------------------------------------------------------
# Route53 Resolver Rule Foward
# ----------------------------------------------------------------------------------------------
resource "aws_route53_resolver_rule_association" "foward_master_local" {
  depends_on       = [aws_ram_resource_share_accepter.resolver_foward_master_local]
  resolver_rule_id = var.route53_resolver_rule_id_forward_master_local
  vpc_id           = module.networking.vpc_id
}

# ----------------------------------------------------------------------------------------------
# Route53 Resolver Rule Foward
# ----------------------------------------------------------------------------------------------
resource "aws_route53_resolver_rule_association" "foward_master_aws" {
  depends_on       = [aws_ram_resource_share_accepter.resolver_foward_master_aws]
  resolver_rule_id = var.route53_resolver_rule_id_forward_master_aws
  vpc_id           = module.networking.vpc_id
}

# ----------------------------------------------------------------------------------------------
# Route53 Resolver Rule System
# ----------------------------------------------------------------------------------------------
resource "aws_route53_resolver_rule_association" "system" {
  depends_on       = [aws_ram_resource_share_accepter.resolver_system]
  resolver_rule_id = var.route53_resolver_rule_id_system
  vpc_id           = module.networking.vpc_id
}
