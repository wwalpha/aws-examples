# ----------------------------------------------------------------------------------------------
# AWS CloudWatch Log Group - Step Function
# ----------------------------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "sfn" {
  name              = "/aws/vendedlogs/states/monitoring-agent-config-distrubute-Logs"
  retention_in_days = 30
}
