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
