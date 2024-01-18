# ----------------------------------------------------------------------------------------------
# AWS IoT Topic Rule - Create Thing
# ----------------------------------------------------------------------------------------------
resource "aws_iot_topic_rule" "create_thing" {
  name        = "${var.prefix}_CreateThingRule"
  description = "Insert new IOT Thing reference into DynamoDB"
  enabled     = true
  sql         = "SELECT thingName as chargePointId, timestamp FROM '$aws/events/thing/+/created'"
  sql_version = "2016-03-23"

  dynamodbv2 {
    role_arn = var.iot_rule_create_thing_role_arn
    put_item {
      table_name = var.dynamodb_table_charge_point
    }
  }
}

# ----------------------------------------------------------------------------------------------
# AWS IoT Topic Rule - Delete Thing
# ----------------------------------------------------------------------------------------------
resource "aws_iot_topic_rule" "delete_thing" {
  name        = "${var.prefix}_DeleteThingRule"
  description = "Delete an IOT Thing reference from DynamoDB"
  enabled     = true
  sql         = "SELECT thingName as chargePointId, timestamp FROM '$aws/events/thing/+/deleted'"
  sql_version = "2016-03-23"

  sqs {
    queue_url  = aws_sqs_queue.deleted_things.url
    role_arn   = var.iot_rule_delete_thing_role_arn
    use_base64 = false
  }
}

# ----------------------------------------------------------------------------------------------
# AWS IoT Topic Rule - Message from Charge Points
# ----------------------------------------------------------------------------------------------
resource "aws_iot_topic_rule" "msg_from_charge_points" {
  name        = "${var.prefix}_MessagesFromChargePointsRule"
  description = "Insert messages coming from Charge Points into an SQS queue to be processed by the message processor"
  enabled     = true
  sql         = "SELECT * as message,topic(1) as chargePointId FROM '+/in'"
  sql_version = "2016-03-23"

  sqs {
    queue_url  = aws_sqs_queue.incoming_messages.url
    role_arn   = var.iot_rule_message_from_charge_points_role_arn
    use_base64 = false
  }
}
