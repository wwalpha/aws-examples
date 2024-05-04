variable "prefix" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
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

variable "transit_gateway_id" {
  description = "The ID of the Transit Gateway"
}

variable "ram_transit_gateway" {}

variable "ram_resolver_system" {}

variable "ram_resolver_forward" {}

variable "domain_name" {}

variable "vpc_id_central_dns" {}
