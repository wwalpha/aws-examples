# ----------------------------------------------------------------------------------------------
# Data Sources
# ----------------------------------------------------------------------------------------------
data "aws_ssoadmin_instances" "this" {}

data "aws_caller_identity" "current" {}

data "aws_ami" "windows" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }
}
