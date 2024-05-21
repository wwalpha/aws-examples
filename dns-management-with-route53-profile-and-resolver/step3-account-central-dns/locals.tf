locals {
  vpc_cidr_block_cloud = "10.0.0.0/8"
}

data "aws_route53_resolver_rule" "forward_onpremise" {
  domain_name = var.resolver_rule_domain_name_forward_onpremise
  rule_type   = "FORWARD"
}

data "aws_route53_resolver_rule" "forward_ssm_endpoint" {
  domain_name = var.resolver_rule_domain_name_forward_ssm_endpoint
  rule_type   = "FORWARD"
}
