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
# Workload App1 - ALB DNS Name
# ----------------------------------------------------------------------------------------------
output "workload_app1_alb_dns_name" {
  value = module.step2_account_workload_app1.alb_dns_name
}

# ----------------------------------------------------------------------------------------------
# Workload App2 - ALB DNS Name
# ----------------------------------------------------------------------------------------------
output "workload_app2_alb_dns_name" {
  value = module.step2_account_workload_app2.alb_dns_name
}
