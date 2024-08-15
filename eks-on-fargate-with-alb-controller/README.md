# EKS on Fargate with AWS Load Balancer Controller

## Prerequisites
- Terraform
- AWS CLI

## Install kubernetes tools
```sh
$ curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
$ sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
$ kubectl version --client
Client Version: v1.31.0
Kustomize Version: v5.4.2

$ ARCH=amd64
$ PLATFORM=$(uname -s)_$ARCH
$ curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
$ tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
$ sudo mv /tmp/eksctl /usr/local/bin
```

## Create AWS Environment
```sh
$ terraform init
$ terraform apply -auto-approve
Outputs:

AWSLoadBalancerControllerIAMPolicyArn = "arn:aws:iam::999999999999:policy/eks-on-fargate-AWSLoadBalancerControllerIAMPolicy"
aws_region = "ap-northeast-1"
aws_vpc_id = "vpc-07cc9ebf94709d04e"
eks_cluster_endpoint = "https://88B9F025A235D8A7FB6275CDC9FACB20.gr7.ap-northeast-1.eks.amazonaws.com"
eks_cluster_name = "eks-on-fargate-cluster"

# terraform output mapping to environment variables
$ AWS_REGION=$(terraform output -raw aws_region)
$ AWS_VPC_ID=$(terraform output -raw aws_vpc_id)
$ EKS_CLUSTER=$(terraform output -raw eks_cluster_name)
```

## Configure EKS
```sh
# update kube config
aws eks update-kubeconfig --name $EKS_CLUSTER --region $AWS_REGION

# give aws console full access
kubectl apply -f https://s3.us-west-2.amazonaws.com/amazon-eks/docs/eks-console-full-access.yaml

# Map the IAM principal to the Kubernetes user or group in the aws-auth ConfigMap
eksctl get iamidentitymapping --cluster $EKS_CLUSTER --region=$AWS_REGION

eksctl create iamidentitymapping \
    --cluster $EKS_CLUSTER \
    --region=$AWS_REGION \
    --arn arn:aws:iam::334678299258:user/ktou@dxc.com \
    --group eks-console-dashboard-full-access-group \
    --no-duplicate-arns


eksctl create iamidentitymapping \
    --cluster my-cluster \
    --region=region-code \
    --arn arn:aws:iam::111122223333:user/my-user \
    --group eks-console-dashboard-restricted-access-group \
    --no-duplicate-arns

```

## Install kubernetes add-ons
```sh
# create iam service account
eksctl create iamserviceaccount \
  --cluster=eks-on-fargate-cluster \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn=[AWSLoadBalancerControllerIAMPolicyArn] \
  --override-existing-serviceaccounts \
  --approve

eksctl create iamserviceaccount \
  --cluster=$EKS_CLUSTER \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn=arn:aws:iam::334678299258:policy/eks-on-fargate-AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve



# install cert manager
kubectl apply \
    --validate=false \
    -f https://github.com/jetstack/cert-manager/releases/download/v1.13.5/cert-manager.yaml

# Install AWS Load Balancer Controller
curl -Lo v2_7_2_full.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.7.2/v2_7_2_full.yaml
sed -i.bak -e '612,620d' ./v2_7_2_full.yaml
sed -i.bak -e 's|your-cluster-name|eks-on-fargate-cluster|' ./v2_7_2_full.yaml
kubectl apply -f v2_7_2_full.yaml

curl -Lo v2_7_2_ingclass.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.7.2/v2_7_2_ingclass.yaml
kubectl apply -f v2_7_2_ingclass.yaml


```

eksctl create iamidentitymapping --cluster $EKS_CLUSTER \
    --region $AWS_REGION \
    --arn "arn:aws:iam::334678299258:user/ktou@dxc.com" \
    --username ktou@dxc.com \
    --group <kubernetes-group-name> \
    --no-duplicate-arns \

CLUSTER_NAME=test-cluster
AWS_REGION=ap-northeast-1
eksctl create cluster --name $CLUSTER_NAME --region $AWS_REGION --fargate
eksctl utils associate-iam-oidc-provider --cluster $CLUSTER_NAME --approve
