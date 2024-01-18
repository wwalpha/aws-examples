# ----------------------------------------------------------------------------------------------
# ECS Task Role Arn
# ----------------------------------------------------------------------------------------------
output "ecs_task_role_arn" {
  value = aws_iam_role.ecs_task.arn
}

# ----------------------------------------------------------------------------------------------
# ECS Task Execution Role Arn
# ----------------------------------------------------------------------------------------------
output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution.arn
}

# ----------------------------------------------------------------------------------------------
# ECS Task Execution Role Arn
# ----------------------------------------------------------------------------------------------
output "iot_rule_delete_thing_role_arn" {
  value = aws_iam_role.delete_thing_rule_action.arn
}

# ----------------------------------------------------------------------------------------------
# ECS Task Execution Role Arn
# ----------------------------------------------------------------------------------------------
output "iot_rule_create_thing_role_arn" {
  value = aws_iam_role.create_thing_rule_action.arn
}

# ----------------------------------------------------------------------------------------------
# ECS Task Execution Role Arn
# ----------------------------------------------------------------------------------------------
output "iot_rule_message_from_charge_points_role_arn" {
  value = aws_iam_role.message_from_charge_points_rule_top.arn
}

# ----------------------------------------------------------------------------------------------
# Lambda Role Arn - Create Thing
# ----------------------------------------------------------------------------------------------
output "lambda_role_arn_create_thing" {
  value = aws_iam_role.lambda_create_thing.arn
}

# ----------------------------------------------------------------------------------------------
# Lambda Role Arn - Delete Thing
# ----------------------------------------------------------------------------------------------
output "lambda_role_arn_delete_thing" {
  value = aws_iam_role.lambda_delete_thing.arn
}

# ----------------------------------------------------------------------------------------------
# Lambda Role Arn - Message Processor
# ----------------------------------------------------------------------------------------------
output "lambda_role_arn_message_processor" {
  value = aws_iam_role.message_processor.arn
}
