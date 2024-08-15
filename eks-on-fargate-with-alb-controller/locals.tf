
locals {
  availability_zones         = ["ap-northeast-1a", "ap-northeast-1d"]
  subnets_cidr_block_public  = ["10.0.0.0/24", "10.0.1.0/24"]
  subnets_cidr_block_private = ["10.0.2.0/24", "10.0.3.0/24"]
  vpc_cidr_block             = "10.0.0.0/16"
}

data "aws_region" "this" {}
