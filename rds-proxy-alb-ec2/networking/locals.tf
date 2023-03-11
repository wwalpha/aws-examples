locals {
  availability_zones          = ["ap-northeast-1a", "ap-northeast-1d"]
  public_subnets_cidr_block   = ["10.10.0.0/24", "10.10.1.0/24"]
  private_subnets_cidr_block  = ["10.10.2.0/24", "10.10.3.0/24"]
  database_subnets_cidr_block = ["10.10.4.0/24", "10.10.5.0/24"]
}
