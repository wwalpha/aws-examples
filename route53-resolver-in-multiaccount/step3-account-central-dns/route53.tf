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
