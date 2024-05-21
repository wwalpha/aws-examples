variable "prefix" {
  type = string
}

variable "vpc_id_central_dns" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "alb_internal" {
  default = false
}

variable "subnets_cidr_block_public" {
  type = list(string)
}

variable "subnets_cidr_block_private" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "domain_name" {}

variable "transit_gateway_id" {
  description = "The ID of the Transit Gateway"
}

variable "ec2_keypair_name" {}
