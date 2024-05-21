variable "prefix" {
  type = string
}

variable "aws_domain_name" {}

variable "vpc_id_central_dns" {}

variable "vpc_id_onpremise" {}

variable "vpc_id_app1" {}

variable "vpc_id_app2" {}

variable "vpc_cidr_block_central_dns" {}

variable "vpc_cidr_block_onpremise" {}

variable "vpc_cidr_block_app1" {}

variable "vpc_cidr_block_app2" {}

variable "alb_dns_name_app1" {}

variable "alb_dns_name_app2" {}

variable "alb_zone_id_app1" {}

variable "alb_zone_id_app2" {}

variable "transit_gateway_id" {}

variable "transit_gateway_attachment_id_central_dns" {}

variable "transit_gateway_attachment_id_onpremise" {}

variable "transit_gateway_attachment_id_workload_app1" {}

variable "transit_gateway_attachment_id_workload_app2" {}

