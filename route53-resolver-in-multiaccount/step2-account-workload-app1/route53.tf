# ----------------------------------------------------------------------------------------------
# Route53 Hosted Zone - Private
# ----------------------------------------------------------------------------------------------
resource "aws_route53_zone" "this" {
  depends_on    = [module.networking]
  name          = "app1.${var.domain_name}"
  force_destroy = true

  vpc {
    vpc_id = module.networking.vpc_id
  }
}

# ----------------------------------------------------------------------------------------------
# Route53 Resolver Rule
# ----------------------------------------------------------------------------------------------
data "aws_ram_resource_share" "resolver" {
  name           = "${var.prefix}_resolver_rules"
  resource_owner = "OTHER-ACCOUNTS"
}

resource "aws_route53_resolver_rule_association" "this" {
  resolver_rule_id = split(data.aws_ram_resource_share.resolver.resource_arns[0], ",")[1]
  vpc_id           = module.networking.vpc_id
}
