# ----------------------------------------------------------------------------------------------
# AWS VPC ID - Onpremise VPC
# ----------------------------------------------------------------------------------------------
output "vpc_id_onpremise" {
  value = aws_vpc.onpremise.id
}

# ----------------------------------------------------------------------------------------------
# AWS VPC Subnets - Onpremise Private Subnets
# ----------------------------------------------------------------------------------------------
output "vpc_subnets_onpremise" {
  value = aws_subnet.onpremise[*].id
}

# ----------------------------------------------------------------------------------------------
# AWS Route53 Resolver Inbound Endpoints
# ----------------------------------------------------------------------------------------------
output "route53_resolver_inbound_endpoints" {
  value = aws_route53_resolver_endpoint.inbound.ip_address[*].ip
}

# ----------------------------------------------------------------------------------------------
# AWS Route53 Resolver Outbound Endpoints
# ----------------------------------------------------------------------------------------------
output "route53_resolver_outbound_endpoints" {
  value = aws_route53_resolver_endpoint.outbound.ip_address[*].ip
}

# # ----------------------------------------------------------------------------------------------
# # AWS VPC ID - Inspection VPC
# # ----------------------------------------------------------------------------------------------
# output "vpc_id_inspection" {
#   value = aws_vpc.inspection.id
# }

# # ----------------------------------------------------------------------------------------------
# # AWS VPC ID - Workload Intra VPC
# # ----------------------------------------------------------------------------------------------
# output "vpc_id_workload_intra" {
#   value = aws_vpc.workload_intra.id
# }

# # ----------------------------------------------------------------------------------------------
# # AWS VPC ID - Workload Web VPC
# # ----------------------------------------------------------------------------------------------
# output "vpc_id_workload_web" {
#   value = aws_vpc.workload_web.id
# }

# # ----------------------------------------------------------------------------------------------
# # AWS VPC Subnets - Workload Intra Private Subnets
# # ----------------------------------------------------------------------------------------------
# output "vpc_subnets_workload_intra_private" {
#   value = aws_subnet.workload_intra_private[*].id
# }

# # ----------------------------------------------------------------------------------------------
# # AWS VPC Subnets - Workload Web Public Subnets
# # ----------------------------------------------------------------------------------------------
# output "vpc_subnets_workload_web_public" {
#   value = aws_subnet.workload_web_public[*].id
# }

# # ----------------------------------------------------------------------------------------------
# # AWS VPC Subnets - Workload Web Private Subnets
# # ----------------------------------------------------------------------------------------------
# output "vpc_subnets_workload_web_private" {
#   value = aws_subnet.workload_web_private[*].id
# }

# # ----------------------------------------------------------------------------------------------
# # AWS VPC Subnets - Ingress Public Subnets
# # ----------------------------------------------------------------------------------------------
# output "vpc_subnets_ingress_public" {
#   value = aws_subnet.ingress_public[*].id
# }
