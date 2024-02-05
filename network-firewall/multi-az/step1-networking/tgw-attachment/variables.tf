variable "prefix" {
  description = "The prefix to use for all resources"
}


variable "transit_gateway_id" {
  description = "The ID of the Transit Gateway"
}

variable "dns_support" {
  description = "Enable or disable DNS support"
  type        = string
  default     = "enable"
}

variable "appliance_mode_support" {
  description = "Enable or disable appliance mode support"
  type        = string
  default     = "disable"
}

variable "transit_gateway_default_route_table_association" {
  description = "Enable or disable automatic association with the default association route table"
  type        = bool
  default     = false
}

variable "transit_gateway_default_route_table_propagation" {
  description = "Enable or disable automatic propagation with the default propagation route table"
  type        = bool
  default     = false
}

variable "transit_gateway_route_destination_cidr_block" {
  description = "The CIDR block of the Transit Gateway Route"
  type        = string
}

variable "transit_gateway_route_table_tags" {
  description = "Tags to apply to the Transit Gateway Route Table"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "subnet_ids" {
  description = "The IDs of the Subnets"
}

variable "transit_gateway_vpc_attachment_tags" {
  description = "Tags to apply to the Transit Gateway VPC Attachment"
  type        = map(string)
  default     = {}
}


