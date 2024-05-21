# # ----------------------------------------------------------------------------------------------
# # AWS Resource Access Manager Share - Resolver Rules Forward master.local
# # ----------------------------------------------------------------------------------------------
# resource "aws_ram_resource_share" "resolver_forward_onpremise" {
#   name                      = "${var.prefix}_resolver_rules_forward_master_local"
#   allow_external_principals = false
# }

# # ----------------------------------------------------------------------------------------------
# # AWS Resource Access Manager Resource Association - Resolver Rules Forward
# # ----------------------------------------------------------------------------------------------
# resource "aws_ram_resource_association" "resolver_forward_onpremise" {
#   resource_arn       = aws_route53_resolver_rule.forward_master_local.arn
#   resource_share_arn = aws_ram_resource_share.resolver_forward_onpremise.arn
# }

# # ----------------------------------------------------------------------------------------------
# # AWS Resource Access Manager Principal Association - Resolver Rules Forward
# # ----------------------------------------------------------------------------------------------
# resource "aws_ram_principal_association" "resolver_forward_onpremise" {
#   for_each           = toset(var.principal_accounts)
#   principal          = each.value
#   resource_share_arn = aws_ram_resource_share.resolver_forward_onpremise.arn
# }

# # ----------------------------------------------------------------------------------------------
# # AWS Resource Access Manager Share - Resolver Rules Forward master.aws
# # ----------------------------------------------------------------------------------------------
# resource "aws_ram_resource_share" "resolver_forward_cloud" {
#   name                      = "${var.prefix}_resolver_rules_forward_master_aws"
#   allow_external_principals = false
# }

# # ----------------------------------------------------------------------------------------------
# # AWS Resource Access Manager Resource Association - Resolver Rules Forward master.aws
# # ----------------------------------------------------------------------------------------------
# resource "aws_ram_resource_association" "resolver_forward_cloud" {
#   resource_arn       = aws_route53_resolver_rule.forward_master_aws.arn
#   resource_share_arn = aws_ram_resource_share.resolver_forward_cloud.arn
# }

# # ----------------------------------------------------------------------------------------------
# # AWS Resource Access Manager Principal Association - Resolver Rules Forward master.aws
# # ----------------------------------------------------------------------------------------------
# resource "aws_ram_principal_association" "resolver_forward_cloud" {
#   for_each           = toset(var.principal_accounts)
#   principal          = each.value
#   resource_share_arn = aws_ram_resource_share.resolver_forward_cloud.arn
# }

# # ----------------------------------------------------------------------------------------------
# # AWS Resource Access Manager Share - Resolver Rules Forward SSM Endpoint
# # ----------------------------------------------------------------------------------------------
# resource "aws_ram_resource_share" "resolver_forward_ssm_endpoint" {
#   name                      = "${var.prefix}_resolver_rules_forward_ssm_endpoint"
#   allow_external_principals = false
# }

# # ----------------------------------------------------------------------------------------------
# # AWS Resource Access Manager Resource Association - Resolver Rules Forward SSM Endpoint
# # ----------------------------------------------------------------------------------------------
# resource "aws_ram_resource_association" "resolver_forward_ssm_endpoint" {
#   resource_arn       = aws_route53_resolver_rule.forward_ssm_endpoint.arn
#   resource_share_arn = aws_ram_resource_share.resolver_forward_ssm_endpoint.arn
# }

# # ----------------------------------------------------------------------------------------------
# # AWS Resource Access Manager Principal Association - Resolver Rules Forward master.aws
# # ----------------------------------------------------------------------------------------------
# resource "aws_ram_principal_association" "resolver_forward_ssm_endpoint" {
#   for_each           = toset(var.principal_accounts)
#   principal          = each.value
#   resource_share_arn = aws_ram_resource_share.resolver_forward_ssm_endpoint.arn
# }

# # ----------------------------------------------------------------------------------------------
# # AWS Resource Access Manager Share - Resolver Rules System
# # ----------------------------------------------------------------------------------------------
# resource "aws_ram_resource_share" "resolver_system" {
#   name                      = "${var.prefix}_resolver_rules_system"
#   allow_external_principals = false
# }

# # ----------------------------------------------------------------------------------------------
# # AWS Resource Access Manager Resource Association - Resolver Rules System
# # ----------------------------------------------------------------------------------------------
# resource "aws_ram_resource_association" "resolver_system" {
#   resource_arn       = aws_route53_resolver_rule.system.arn
#   resource_share_arn = aws_ram_resource_share.resolver_system.arn
# }

# # ----------------------------------------------------------------------------------------------
# # AWS Resource Access Manager Principal Association
# # ----------------------------------------------------------------------------------------------
# resource "aws_ram_principal_association" "resolver_system" {
#   for_each           = toset(var.principal_accounts)
#   principal          = each.value
#   resource_share_arn = aws_ram_resource_share.resolver_system.arn
# }

# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Share - Transit Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_share" "tgw" {
  name                      = "${var.prefix}_transit_gateway"
  allow_external_principals = false
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

# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Share - Route53 Profile
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_share" "route53_profile" {
  name                      = "${var.prefix}_route53_profile"
  allow_external_principals = false
}

# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Resource Association - Route53 Profile
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_association" "route53_profile" {
  resource_arn       = var.route53_profile_arn
  resource_share_arn = aws_ram_resource_share.route53_profile.arn
}

# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Principal Association - Route53 Profile
# ----------------------------------------------------------------------------------------------
resource "aws_ram_principal_association" "route53_profile" {
  for_each           = toset(var.principal_accounts)
  principal          = each.value
  resource_share_arn = aws_ram_resource_share.route53_profile.arn
}
