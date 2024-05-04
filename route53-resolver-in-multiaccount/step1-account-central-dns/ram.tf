# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Share - Resolver Rules Forward
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_share" "resolver_rule_forward" {
  name                      = "${var.prefix}_resolver_rules_forward"
  allow_external_principals = true
}

# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Resource Association - Resolver Rules Forward
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_association" "resolver_rule_forward" {
  resource_arn       = aws_route53_resolver_rule.foward.arn
  resource_share_arn = aws_ram_resource_share.resolver_rule_forward.arn
}

# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Principal Association - Resolver Rules Forward
# ----------------------------------------------------------------------------------------------
resource "aws_ram_principal_association" "resolver_rule_forward" {
  for_each           = toset(var.principal_accounts)
  principal          = each.value
  resource_share_arn = aws_ram_resource_share.resolver_rule_forward.arn
}

# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Share - Resolver Rules System
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_share" "resolver_rule_system" {
  name                      = "${var.prefix}_resolver_rules_system"
  allow_external_principals = true
}

# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Resource Association - Resolver Rules System
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_association" "resolver_rule_system" {
  resource_arn       = aws_route53_resolver_rule.system.arn
  resource_share_arn = aws_ram_resource_share.resolver_rule_system.arn
}

# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Principal Association
# ----------------------------------------------------------------------------------------------
resource "aws_ram_principal_association" "resolver_rule_system" {
  for_each           = toset(var.principal_accounts)
  principal          = each.value
  resource_share_arn = aws_ram_resource_share.resolver_rule_system.arn
}

# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Share - Transit Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_share" "tgw" {
  name                      = "${var.prefix}_transit_gateway"
  allow_external_principals = true
}

# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Resource Association - Transit Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_association" "tgw" {
  resource_arn       = aws_ec2_transit_gateway.this.arn
  resource_share_arn = aws_ram_resource_share.tgw.arn
}

# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Principal Association - Transit Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_ram_principal_association" "tgw" {
  for_each           = toset(var.principal_accounts)
  principal          = each.value
  resource_share_arn = aws_ram_resource_share.tgw.arn
}
