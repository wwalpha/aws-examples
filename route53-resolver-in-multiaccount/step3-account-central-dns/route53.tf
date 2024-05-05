# ----------------------------------------------------------------------------------------------
# Route53 Zone Association - app1
# ----------------------------------------------------------------------------------------------
resource "aws_route53_zone_association" "app1" {
  vpc_id  = var.vpc_id_central_dns
  zone_id = var.hosted_zone_id_app1
}

# ----------------------------------------------------------------------------------------------
# Route53 Zone Association - app2
# ----------------------------------------------------------------------------------------------
resource "aws_route53_zone_association" "app2" {
  vpc_id  = var.vpc_id_central_dns
  zone_id = var.hosted_zone_id_app2
}


# ----------------------------------------------------------------------------------------------
# AWS Route - Transit Gateway
# ----------------------------------------------------------------------------------------------
resource "aws_route" "tgw" {
  depends_on             = [module.networking]
  for_each               = toset(module.networking.vpc_private_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = local.vpc_cidr_block_cloud
  transit_gateway_id     = aws_ec2_transit_gateway.this.id
}
