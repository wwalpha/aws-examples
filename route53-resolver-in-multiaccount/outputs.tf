# ----------------------------------------------------------------------------------------------
# AWS Route53 Resolver Inbound Endpoints
# ----------------------------------------------------------------------------------------------
output "route53_resolver_inbound_endpoints" {
  value = [for i in module.step1_account_central_dns.route53_resolver_inbound_endpoints : i.ip]
}

# ----------------------------------------------------------------------------------------------
# AWS Route53 Resolver Outbound Endpoints
# ----------------------------------------------------------------------------------------------
output "route53_resolver_outbound_endpoints" {
  value = [for i in module.step1_account_central_dns.route53_resolver_outbound_endpoints : i.ip]
}

# ----------------------------------------------------------------------------------------------
# AWS Route53 Resolver ID - Forward Onpremise (master.local)
# ----------------------------------------------------------------------------------------------
output "route53_resolver_id_forward_onpremise" {
  value = module.step1_account_central_dns.resolver_rule_id_forward_onpremise
}

# ----------------------------------------------------------------------------------------------
# AWS Route53 Resolver ID - Forward Cloud (master.aws)
# ----------------------------------------------------------------------------------------------
output "route53_resolver_id_forward_cloud" {
  value = module.step1_account_central_dns.resolver_rule_id_forward_cloud
}

# ----------------------------------------------------------------------------------------------
# AWS Route53 Resolver ID - System
# ----------------------------------------------------------------------------------------------
output "route53_resolver_id_system" {
  value = module.step1_account_central_dns.resolver_rule_id_system
}

# ----------------------------------------------------------------------------------------------
# Workload App1 - ALB Private IPs
# ----------------------------------------------------------------------------------------------
# output "workload_app1_alb_private_ips" {
#   value = module.step1_account_central_dns.resolver_rule_id_system
# }
