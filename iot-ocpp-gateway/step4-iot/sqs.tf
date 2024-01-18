# ----------------------------------------------------------------------------------------------
# AWS SQS Queue - Incoming Messages
# ----------------------------------------------------------------------------------------------
resource "aws_sqs_queue" "incoming_messages" {
  name                              = "${var.prefix}-IncomingMessagesQueue"
  visibility_timeout_seconds        = 30
  max_message_size                  = 262144
  message_retention_seconds         = 345600
  sqs_managed_sse_enabled           = true
  kms_data_key_reuse_period_seconds = 300
  receive_wait_time_seconds         = 0

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dead_queue_for_incoming_messages.arn
    maxReceiveCount     = 3
  })
}

# ----------------------------------------------------------------------------------------------
# AWS SQS Queue - DeadLetter Queue For Incoming Messages
# ----------------------------------------------------------------------------------------------
resource "aws_sqs_queue" "dead_queue_for_incoming_messages" {
  name                              = "${var.prefix}-DeadLetterQueueForIncomingMessages"
  kms_data_key_reuse_period_seconds = 300
  max_message_size                  = 262144
  message_retention_seconds         = 345600
  receive_wait_time_seconds         = 0
  sqs_managed_sse_enabled           = true
  visibility_timeout_seconds        = 30
}

# ----------------------------------------------------------------------------------------------
# AWS SQS Queue - Deleted Things Queue
# ----------------------------------------------------------------------------------------------
resource "aws_sqs_queue" "deleted_things" {
  name                              = "${var.prefix}-DeletedThingsQueue"
  kms_data_key_reuse_period_seconds = 300
  max_message_size                  = 262144
  message_retention_seconds         = 345600
  receive_wait_time_seconds         = 0
  visibility_timeout_seconds        = 30
  sqs_managed_sse_enabled           = true

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dead_queue_for_deleted_things.arn
    maxReceiveCount     = 3
  })
}

# ----------------------------------------------------------------------------------------------
# AWS SQS Queue - DeadLetter Queue For Deleted Things
# ----------------------------------------------------------------------------------------------
resource "aws_sqs_queue" "dead_queue_for_deleted_things" {
  name                              = "${var.prefix}-DeadLetterQueueForDeletedThings"
  kms_data_key_reuse_period_seconds = 300
  max_message_size                  = 262144
  message_retention_seconds         = 345600
  receive_wait_time_seconds         = 0
  sqs_managed_sse_enabled           = true
  visibility_timeout_seconds        = 30
}

# ----------------------------------------------------------------------------------------------
# AWS SQS Queue Policy - DeadLetter Queue For Deleted Things
# ----------------------------------------------------------------------------------------------
resource "aws_sqs_queue_policy" "dead_queue_for_deleted_things" {
  policy    = "{\"Statement\":[{\"Action\":\"sqs:*\",\"Condition\":{\"Bool\":{\"aws:SecureTransport\":\"false\"}},\"Effect\":\"Deny\",\"Principal\":{\"AWS\":\"*\"},\"Resource\":\"arn:aws:sqs:ap-northeast-1:334678299258:AwsOcppGatewayStack-DeadLetterQueueForDeletedThings5875D721-kOhGAmRbogkV\"}],\"Version\":\"2012-10-17\"}"
  queue_url = aws_sqs_queue.dead_queue_for_deleted_things.url
}
