output "eks_cluster_name" {
  value = aws_eks_cluster.this.name
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "AWSLoadBalancerControllerIAMPolicyArn" {
  value = aws_iam_policy.AWSLoadBalancerControllerIAMPolicy.arn
}

output "aws_region" {
  value = data.aws_region.this.name
}

output "aws_account_id" {
  value = data.aws_caller_identity.this.account_id
}
