variable "prefix" {
  type = string
}

variable "name_servers_app1" {
  type = list(string)
}

variable "name_servers_app2" {
  type = list(string)
}

variable "domain_name" {
}

variable "route53_hosted_zone_id" {
}

variable "transit_gateway_id" {}

# variable "vpc_id_central_dns" {
#   description = "VPC ID for the central DNS VPC"
# }

variable "vpc_cidr_block_central_dns" {}

variable "vpc_cidr_block_onpremise" {}

variable "vpc_cidr_block_workload_app1" {}

variable "vpc_cidr_block_workload_app2" {}

variable "transit_gateway_attachment_id_central_dns" {}

variable "transit_gateway_attachment_id_onpremise" {}

variable "transit_gateway_attachment_id_workload_app1" {}

variable "transit_gateway_attachment_id_workload_app2" {}

