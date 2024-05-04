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

# variable "ram_resource_share_arn" {
#   description = "The ARN of the RAM Resource Share"
# }
