variable "prefix" {}

variable "transit_gateway_id" {}

variable "vpc_id_central_dns" {
  description = "VPC ID for the central DNS VPC"
}

variable "vpc_cidr_block_central_dns" {}

variable "vpc_cidr_block_onpremise" {}

variable "vpc_cidr_block_workload_app1" {}

variable "vpc_cidr_block_workload_app2" {}

variable "transit_gateway_attachment_id_central_dns" {}

variable "transit_gateway_attachment_id_onpremise" {}

variable "transit_gateway_attachment_id_workload_app1" {}

variable "transit_gateway_attachment_id_workload_app2" {}

variable "route53_resolver_subnets" {}
