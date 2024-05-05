# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Share - Resolver Rules Forward master.local
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_share" "resolver_rule_forward_master_local" {
  name                      = "${var.prefix}_resolver_rules_forward_master_local"
  allow_external_principals = true
}

# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Resource Association - Resolver Rules Forward
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_association" "resolver_rule_forward_master_local" {
  resource_arn       = aws_route53_resolver_rule.forward_master_local.arn
  resource_share_arn = aws_ram_resource_share.resolver_rule_forward_master_local.arn
}

# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Principal Association - Resolver Rules Forward
# ----------------------------------------------------------------------------------------------
resource "aws_ram_principal_association" "resolver_rule_forward_master_local" {
  for_each           = toset(var.principal_accounts)
  principal          = each.value
  resource_share_arn = aws_ram_resource_share.resolver_rule_forward_master_local.arn
}

# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Share - Resolver Rules Forward master.aws
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_share" "resolver_rule_forward_master_aws" {
  name                      = "${var.prefix}_resolver_rules_forward_master_aws"
  allow_external_principals = true
}

# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Resource Association - Resolver Rules Forward master.aws
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_association" "resolver_rule_forward_master_aws" {
  resource_arn       = aws_route53_resolver_rule.forward_master_aws.arn
  resource_share_arn = aws_ram_resource_share.resolver_rule_forward_master_aws.arn
}

# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Principal Association - Resolver Rules Forward master.aws
# ----------------------------------------------------------------------------------------------
resource "aws_ram_principal_association" "resolver_rule_forward_master_aws" {
  for_each           = toset(var.principal_accounts)
  principal          = each.value
  resource_share_arn = aws_ram_resource_share.resolver_rule_forward_master_aws.arn
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
