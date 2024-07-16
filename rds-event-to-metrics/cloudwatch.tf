# ----------------------------------------------------------------------------------------------
# AWS CloudWatch Log Group - Step Function
# ----------------------------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "sfn" {
  name              = "/aws/vendedlogs/states/rdsevents-to-metrics"
  retention_in_days = 7
}
