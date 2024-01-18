variable "prefix" {}

variable "ecs_execution_role_arn" {}
variable "ecs_task_role_arn" {}

variable "vpc_id" {}
variable "vpc_cidr_block" {}
variable "vpc_private_subnet_ids" {
  type = list(string)
}
variable "vpc_public_subnet_ids" {
  type = list(string)
}
variable "dynamodb_table_charge_point" {}

variable "iot_amazon_root_ca_arn" {}
variable "iot_pem_certificate_arn" {}
variable "iot_public_key_arn" {}
variable "iot_private_key_arn" {}

variable "lambda_role_arn_create_thing" {}
variable "lambda_role_arn_delete_thing" {}
variable "lambda_role_arn_message_processor" {}

variable "sqs_arn_incoming_message" {}
variable "sqs_arn_delete_thing" {}
