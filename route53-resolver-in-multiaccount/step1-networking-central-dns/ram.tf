# ----------------------------------------------------------------------------------------------
# AWS Resource Access Manager Share Accepter
# ----------------------------------------------------------------------------------------------
resource "aws_ram_resource_share_accepter" "tis" {
  share_arn = var.ram_resource_share_arn
}