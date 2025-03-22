locals {
  availability_zones             = ["ap-northeast-1a", "ap-northeast-1d"]
  vpc_cidr_block_vpn             = "10.10.0.0/16"
  vpc_cidr_block_01              = "10.20.0.0/16"
  vpc_cidr_block_02              = "10.30.0.0/16"
  private_subnets_cidr_block_vpn = ["10.10.0.0/24", "10.10.1.0/24"]
  private_subnets_cidr_block_01  = ["10.20.0.0/24", "10.20.1.0/24"]
  private_subnets_cidr_block_02  = ["10.30.0.0/24", "10.30.1.0/24"]
}
