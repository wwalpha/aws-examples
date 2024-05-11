# ----------------------------------------------------------------------------------------------
# AWS SNS Topic - Error Notify
# ----------------------------------------------------------------------------------------------
resource "aws_sns_topic" "errors" {
  name = "${local.prefix}-errors"
}

# ----------------------------------------------------------------------------------------------
# AWS SNS Topic Subscription - Email
# ----------------------------------------------------------------------------------------------
resource "aws_sns_topic_subscription" "administrator" {
  topic_arn = aws_sns_topic.error_notify.arn
  protocol  = "email"
  endpoint  = var.admin_email
}
