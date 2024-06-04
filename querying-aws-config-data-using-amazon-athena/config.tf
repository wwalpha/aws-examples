# ----------------------------------------------------------------------------------------------
# AWS Config Configuration Recorder
# ----------------------------------------------------------------------------------------------
resource "aws_config_configuration_recorder" "this" {
  name     = "channel"
  role_arn = "arn:aws:iam::${local.account_id}:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig"
}

# ----------------------------------------------------------------------------------------------
# AWS Config Delivery Channel
# ----------------------------------------------------------------------------------------------
resource "aws_config_delivery_channel" "this" {
  depends_on     = [aws_config_configuration_recorder.this]
  name           = "${local.prefix}-channel"
  s3_bucket_name = aws_s3_bucket.snapshots.bucket

  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }
}

# ----------------------------------------------------------------------------------------------
# AWS Config Configuration Recorder Status
# ----------------------------------------------------------------------------------------------
resource "aws_config_configuration_recorder_status" "this" {
  depends_on = [aws_config_delivery_channel.this]

  name       = aws_config_configuration_recorder.this.name
  is_enabled = true
}
