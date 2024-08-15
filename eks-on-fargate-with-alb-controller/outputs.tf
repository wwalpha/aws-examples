output "eks_cluster_name" {
  value = aws_eks_cluster.this.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "AWSLoadBalancerControllerIAMPolicyArn" {
  value = aws_iam_policy.AWSLoadBalancerControllerIAMPolicy.arn
}

output "aws_vpc_id" {
  value = module.vpc.vpc_id
}

output "aws_region" {
  value = data.aws_region.this.name
}
