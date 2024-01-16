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
