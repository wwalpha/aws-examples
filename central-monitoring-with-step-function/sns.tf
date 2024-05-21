# ----------------------------------------------------------------------------------------------
# AWS SNS Topic - Error Notify
# ----------------------------------------------------------------------------------------------
resource "aws_sns_topic" "nofity" {
  name = "${local.prefix}-topic"
}

# ----------------------------------------------------------------------------------------------
# AWS SNS Topic Subscription - Error Notify
# ----------------------------------------------------------------------------------------------
resource "aws_sns_topic_subscription" "nofity" {
  topic_arn = aws_sns_topic.nofity.arn
  protocol  = "email"
  endpoint  = var.requester
}
