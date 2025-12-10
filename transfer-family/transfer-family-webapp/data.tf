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

data "aws_identitystore_group" "test" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = "test_group"
    }
  }
}
