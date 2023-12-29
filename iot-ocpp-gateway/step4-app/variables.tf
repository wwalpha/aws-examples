variable "prefix" {}

variable "ecs_execution_role_arn" {}
variable "ecs_task_role_arn" {}

variable "vpc_id" {}

variable "vpc_public_subnet_ids" {
  type = list(string)
}
