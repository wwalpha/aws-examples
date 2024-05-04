# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Share
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_share" "this" {
  name                      = "${var.prefix}_resolver_rules"
  allow_external_principals = true
}

# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Resource Association - Resolver Rules
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_association" "this" {
  resource_arn       = aws_route53_resolver_rule.foward2.arn
  resource_share_arn = aws_ram_resource_share.this.arn
}

# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Principal Association
# 
# If both AWS accounts are in the same Organization and RAM Sharing with AWS Organizations is enabled,
# this resource is not necessary as RAM Resource Share invitations are not used.
# ----------------------------------------------------------------------------------------------
resource "aws_ram_principal_association" "this" {
  for_each           = toset(var.principal_accounts)
  principal          = each.value
  resource_share_arn = aws_ram_resource_share.this.arn
}
