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

variable "principal_accounts" {
  type = list(string)
}

variable "cloud_domain_name" {
  type = string
}

variable "onpremise_dns_server_ip" {
  type = string
}


variable "route53_resolver_inbound_endpoint_ip_addresses" {
  type = list(string)
}
variable "route53_resolver_outbound_endpoint_ip_addresses" {
  type = list(string)
}
