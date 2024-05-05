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

variable "ram_invitation_arn_transit_gateway" {}

variable "ram_invitation_arn_resolver_rule_system" {}

variable "ram_invitation_arn_resolver_rule_forward" {}

variable "transit_gateway_id" {
  description = "The ID of the Transit Gateway"
}

variable "route53_resolver_rule_forward_id" {}

variable "route53_resolver_rule_system_id" {}
