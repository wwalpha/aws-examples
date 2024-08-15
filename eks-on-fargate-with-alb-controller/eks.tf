# ----------------------------------------------------------------------------------------------
# EKS Cluster
# ----------------------------------------------------------------------------------------------
resource "aws_eks_cluster" "this" {
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
  ]

  name     = "${var.prefix}-cluster"
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    subnet_ids = module.vpc.private_subnets
  }
}

# ----------------------------------------------------------------------------------------------
# TLS Certificate
# ----------------------------------------------------------------------------------------------
data "tls_certificate" "this" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

# ----------------------------------------------------------------------------------------------
# AWS IAM Openid Connect Provider
# ----------------------------------------------------------------------------------------------
resource "aws_iam_openid_connect_provider" "this" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.this.certificates[0].sha1_fingerprint]
  url             = data.tls_certificate.this.url
}

# ----------------------------------------------------------------------------------------------
# AWS EKS Fargate Profile
# ----------------------------------------------------------------------------------------------
resource "aws_eks_fargate_profile" "this" {
  cluster_name           = aws_eks_cluster.this.name
  fargate_profile_name   = "profile-${var.prefix}"
  pod_execution_role_arn = aws_iam_role.fargate_profile.arn
  subnet_ids             = module.vpc.private_subnets

  selector {
    namespace = var.prefix
  }

  selector {
    namespace = "kube-system"
    labels = {
      "k8s-app" = "kube-dns"
    }
  }
}
