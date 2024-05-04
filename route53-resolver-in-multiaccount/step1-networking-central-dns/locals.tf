locals {
  az_suffix            = [for az in var.availability_zones : split("-", az)[2]]
  vpc_cidr_block_cloud = "10.0.0.0/8"
}
