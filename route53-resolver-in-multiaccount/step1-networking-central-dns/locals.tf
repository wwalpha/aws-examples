locals {
  az_suffix = [for az in var.availability_zones : split("-", az)[2]]

  vpc_cidr_block_cloud = "10.0.0.0/8"

  # ----------------------------------------------------------------------------------------------
  # AWS Route53 Resolver
  # ----------------------------------------------------------------------------------------------
  route53_resolver_inbound_endpoint_address1  = "10.1.0.10"
  route53_resolver_inbound_endpoint_address2  = "10.1.1.10"
  route53_resolver_outbound_endpoint_address1 = "10.1.0.20"
  route53_resolver_outbound_endpoint_address2 = "10.1.1.20"
}
