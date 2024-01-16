locals {
  # account_id   = data.aws_caller_identity.this.account_id
  # region       = data.aws_region.this.name
  # iot_endpoint = data.aws_iot_endpoint.this.endpoint_address
}

# ----------------------------------------------------------------------------------------------
# AWS DynamoDB Table
# ----------------------------------------------------------------------------------------------
data "aws_dynamodb_table" "charge_point" {
  name = var.dynamodb_table_charge_point
}
