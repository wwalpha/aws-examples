# ----------------------------------------------------------------------------------------------
# AWS Route53 Resolver Inbound Endpoints
# ----------------------------------------------------------------------------------------------
output "route53_resolver_inbound_endpoints" {
  value = [for i in module.networking_shared.route53_resolver_inbound_endpoints : i]
}

# ----------------------------------------------------------------------------------------------
# AWS Route53 Resolver Outbound Endpoints
# ----------------------------------------------------------------------------------------------
output "route53_resolver_outbound_endpoints" {
  value = [for i in module.networking_shared.route53_resolver_outbound_endpoints : i]
}
