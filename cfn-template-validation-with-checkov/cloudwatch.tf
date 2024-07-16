# ----------------------------------------------------------------------------------------------
# AWS CloudWatch Log Group - Step Function
# ----------------------------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "sfn" {
  name              = "/aws/vendedlogs/states/cfn-templates-validation"
  retention_in_days = 30
}
