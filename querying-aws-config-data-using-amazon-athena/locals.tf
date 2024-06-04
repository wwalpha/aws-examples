resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

locals {
  prefix                     = "configs"
  suffix                     = random_string.suffix.id
  s3_bucket_config_snapshots = "${local.prefix}-snapshots-${local.suffix}"
  account_id                 = data.aws_caller_identity.this.account_id
}

data "aws_caller_identity" "this" {}
