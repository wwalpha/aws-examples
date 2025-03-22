variable "prefix" {
  type    = string
  default = "centralized-vpn"
}

variable "saml_provider_arn" {
  type = string
}

variable "vpn_group_id_01" {
  type = string
}

variable "vpn_group_id_02" {
  type = string
}

variable "al2023_ami_id" {
  type    = string
  default = "ami-0599b6e53ca798bb2"
}

variable "ec2_keypair_name" {
  type    = string
  default = "demo"
}

variable "client_vpn_server_certificate_arn" {
}
