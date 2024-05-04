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
# AWS Resource Access Manager Principal Association - Central DNS
# ----------------------------------------------------------------------------------------------
resource "aws_ram_principal_association" "central_dns" {
  principal          = var.aws_account_id_central_dns
  resource_share_arn = aws_ram_resource_share.this.arn
}

# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Principal Association - Onpremise
# ----------------------------------------------------------------------------------------------
resource "aws_ram_principal_association" "onpremise" {
  principal          = var.aws_account_id_onpremise
  resource_share_arn = aws_ram_resource_share.this.arn
}

# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Principal Association - Workload Public
# ----------------------------------------------------------------------------------------------
resource "aws_ram_principal_association" "workload_app1" {
  principal          = var.aws_account_id_workload_app1
  resource_share_arn = aws_ram_resource_share.this.arn
}

# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Principal Association - Workload Private
# ----------------------------------------------------------------------------------------------
resource "aws_ram_principal_association" "workload_app2" {
  principal          = var.aws_account_id_workload_app2
  resource_share_arn = aws_ram_resource_share.this.arn
}
