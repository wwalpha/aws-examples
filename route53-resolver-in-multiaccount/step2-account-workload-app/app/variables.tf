variable "prefix" {}

variable "vpc_id" {}
variable "vpc_private_subnet_ids" {}
variable "vpc_public_subnet_ids" {}
variable "alb_internal" {
  default = false
}
