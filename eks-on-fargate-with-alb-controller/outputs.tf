output "eks_cluster_name" {
  value = module.eks.cluster_name
}

# output "kubeconfig-certificate-authority-data" {
#   value = aws_eks_cluster.this.certificate_authority[0].data
# }

output "aws_region" {
  value = data.aws_region.this.name
}

output "aws_account_id" {
  value = data.aws_caller_identity.this.account_id
}

output "tls_certificate" {
  value = module.eks
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
