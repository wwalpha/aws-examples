locals {
  customer_gateway_address_eu = data.aws_instance.router_onpremise_eu.public_ip
  customer_gateway_address_us = data.aws_instance.router_onpremise_us.public_ip
  customer_gateway_address_jp = data.aws_instance.router_onpremise_jp.public_ip

}

data "aws_instance" "router_eu" {
  instance_id = var.instance_id_router_eu
}

data "aws_instance" "router_us" {
  instance_id = var.instance_id_router_us
}

data "aws_instance" "router_jp" {
  instance_id = var.instance_id_router_jp
}
