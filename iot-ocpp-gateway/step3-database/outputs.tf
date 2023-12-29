# ----------------------------------------------------------------------------------------------
# DynamoDB Table Name - Charge Point
# ----------------------------------------------------------------------------------------------
output "dynamodb_table_charge_point" {
  value = aws_dynamodb_table.charge_point.id
}
