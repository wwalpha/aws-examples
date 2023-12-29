# ----------------------------------------------------------------------------------------------
# AWS DynamoDB Table - Charge Point
# ----------------------------------------------------------------------------------------------
resource "aws_dynamodb_table" "charge_point" {
  name                        = "${var.prefix}-ChargePoint"
  billing_mode                = "PAY_PER_REQUEST"
  deletion_protection_enabled = false
  hash_key                    = "chargePointId"
  table_class                 = "STANDARD"

  attribute {
    name = "chargePointId"
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }
}
