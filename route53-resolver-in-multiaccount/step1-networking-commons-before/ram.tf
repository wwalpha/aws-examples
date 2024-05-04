# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Share
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_share" "this" {
  name                      = "${var.prefix}_transit_gateway"
  allow_external_principals = true
}

# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Resource Association - Transit Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_association" "this" {
  resource_arn       = aws_ec2_transit_gateway.this.arn
  resource_share_arn = aws_ram_resource_share.this.arn
}

# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Principal Association
# ----------------------------------------------------------------------------------------------
resource "aws_ram_principal_association" "this" {
  for_each           = toset(var.principal_accounts)
  principal          = each.value
  resource_share_arn = aws_ram_resource_share.this.arn
}
