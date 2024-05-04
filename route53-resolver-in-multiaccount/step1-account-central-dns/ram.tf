# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Share - Resolver Rules
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_share" "resolver" {
  name                      = "${var.prefix}_resolver_rules"
  allow_external_principals = true
}

# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Resource Association - Resolver Rules
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_association" "resolver" {
  resource_arn       = aws_route53_resolver_rule.foward2.arn
  resource_share_arn = aws_ram_resource_share.resolver.arn
}

# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Principal Association
# ----------------------------------------------------------------------------------------------
resource "aws_ram_principal_association" "resolver" {
  for_each           = toset(var.principal_accounts)
  principal          = each.value
  resource_share_arn = aws_ram_resource_share.resolver.arn
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
