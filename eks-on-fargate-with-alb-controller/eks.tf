# ----------------------------------------------------------------------------------------------
# EKS Cluster
# ----------------------------------------------------------------------------------------------
module "eks" {
  source                                 = "terraform-aws-modules/eks/aws"
  cluster_version                        = "1.30"
  cluster_name                           = local.cluster_name
  vpc_id                                 = module.vpc.vpc_id
  subnet_ids                             = module.vpc.private_subnets
  control_plane_subnet_ids               = module.vpc.public_subnets
  enable_irsa                            = true
  create_cluster_security_group          = false
  create_node_security_group             = false
  cluster_endpoint_public_access         = true
  cluster_encryption_config              = {}
  cluster_enabled_log_types              = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  cloudwatch_log_group_retention_in_days = 7
  manage_aws_auth_configmap              = true
  aws_auth_accounts                      = [data.aws_caller_identity.this.account_id]
  aws_auth_users = [
    {
      userarn = "arn:aws:iam::${data.aws_caller_identity.this.account_id}:user/${var.user_name}"
      groups  = ["eks-console-dashboard-full-access-group"]
    }
  ]

  cluster_addons = {
    kube-proxy = {}
    vpc-cni    = {}
    coredns = {
      configuration_values = jsonencode({
        computeType = "Fargate"
      })
    }
  }

  fargate_profiles = {
    default = {
      name         = "default"
      subnet_ids   = module.vpc.private_subnets
      iam_role_arn = aws_iam_role.fargate_profile.arn
      selectors = [
        {
          namespace = "cert-manager"
        },
        {
          namespace = "kube-system"
        }
      ]
    }
  }

}

# ----------------------------------------------------------------------------------------------
# EKS Cluster
# ----------------------------------------------------------------------------------------------
# resource "aws_eks_cluster" "this" {
#   depends_on = [
#     aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
#     aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
#     aws_iam_role_policy_attachment.CloudWatchLogsFullAccess
#   ]

#   name                      = local.cluster_name
#   role_arn                  = aws_iam_role.eks.arn
#   enabled_cluster_log_types = ["api", "audit"]

#   vpc_config {
#     subnet_ids = module.vpc.private_subnets
#   }
# }

# ----------------------------------------------------------------------------------------------
# TLS Certificate
# ----------------------------------------------------------------------------------------------
# data "tls_certificate" "this" {
#   url = aws_eks_cluster.this.identity[0].oidc[0].issuer
# }

# ----------------------------------------------------------------------------------------------
# AWS IAM Openid Connect Provider
# ----------------------------------------------------------------------------------------------
# resource "aws_iam_openid_connect_provider" "this" {
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = [data.tls_certificate.this.certificates[0].sha1_fingerprint]
#   url             = data.tls_certificate.this.url
# }

# ----------------------------------------------------------------------------------------------
# AWS EKS Fargate Profile
# ----------------------------------------------------------------------------------------------
# resource "aws_eks_fargate_profile" "this" {
#   cluster_name           = aws_eks_cluster.this.name
#   fargate_profile_name   = "profile-${var.prefix}"
#   pod_execution_role_arn = aws_iam_role.fargate_profile.arn
#   subnet_ids             = module.vpc.private_subnets

#   selector {
#     namespace = var.prefix
#   }

#   selector {
#     namespace = "kube-system"
#   }

#   selector {
#     namespace = "cert-manager"
#   }
# }

# ----------------------------------------------------------------------------------------------
# AWS EKS Addon - vpc-cni
# ----------------------------------------------------------------------------------------------
# resource "aws_eks_addon" "vpc_cni" {
#   cluster_name                = aws_eks_cluster.this.name
#   addon_name                  = "vpc-cni"
#   addon_version               = "v1.18.1-eksbuild.3"
#   resolve_conflicts_on_update = "PRESERVE"
# }
