# EKS on Fargate with AWS Load Balancer Controller

## Prerequisites
- Terraform
- AWS CLI
- kubectl
- eksctl

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

## Create EKS Cluster
```sh
$ terraform init
$ terraform apply -auto-approve
Outputs:

AWSLoadBalancerControllerIAMPolicyArn = "arn:aws:iam::999999999999:policy/eks-on-fargate-AWSLoadBalancerControllerIAMPolicy"
aws_account_id = "999999999999"
aws_region = "ap-northeast-1"
eks_cluster_name = "eks-on-fargate-cluster"

# terraform output mapping to environment variables
$ AWS_REGION=$(terraform output -raw aws_region)
$ AWS_ACCOUNT_ID=$(terraform output -raw aws_account_id)
$ EKS_CLUSTER=$(terraform output -raw eks_cluster_name)
$ AWSLoadBalancerControllerIAMPolicyArn=$(terraform output -raw AWSLoadBalancerControllerIAMPolicyArn)

```

## Configure EKS
```sh
# update kube config
aws eks update-kubeconfig --name $EKS_CLUSTER --region $AWS_REGION

# give aws console full access
kubectl apply -f https://s3.us-west-2.amazonaws.com/amazon-eks/docs/eks-console-full-access.yaml

# Map the IAM principal to the Kubernetes user or group in the aws-auth ConfigMap
eksctl create iamidentitymapping \
    --cluster $EKS_CLUSTER \
    --region=$AWS_REGION \
    --arn arn:aws:iam::$AWS_ACCOUNT_ID:user/test@test.com \
    --group eks-console-dashboard-full-access-group \
    --no-duplicate-arns

# Check auth mapping settings
eksctl get iamidentitymapping --cluster $EKS_CLUSTER --region=$AWS_REGION

# remove the eks.amazonaws.com/compute-type : ec2 annotation from the CoreDNS Pods.
kubectl patch deployment coredns -n kube-system --type json \
    -p='[{"op": "remove", "path": "/spec/template/metadata/annotations/eks.amazonaws.com~1compute-type"}]'

# restart coredns
kubectl rollout restart -n kube-system deployment coredns

# wait coredns status changes to running
kubectl get pods --all-namespaces

--------------------------------------------------------------------------
NAMESPACE     NAME                       READY   STATUS    RESTARTS   AGE
kube-system   coredns-5654d57f78-qpj7v   1/1     Running   0          12m
kube-system   coredns-5654d57f78-sxhrk   1/1     Running   0          12m
```

## Install kubernetes add-ons
```sh
# create iam service account
eksctl create iamserviceaccount \
  --cluster=$EKS_CLUSTER \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn=AWSLoadBalancerControllerIAMPolicyArn \
  --approve

# Install cert manager (https://github.com/jetstack/cert-manager/releases/download/v1.13.5/cert-manager.yaml)
kubectl apply -f ./add-ons/cert-manager-v1.13.5.yaml

# wait cert-manager status changes to running
kubectl get pods --namespace cert-manager

# Install AWS Load Balancer Controller (https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.7.2/v2_7_2_full.yaml)
# sed -i.bak -e '612,620d' ./v2_7_2_full.yaml
# sed -i.bak -e 's|your-cluster-name|$EKS_CLUSTER|' ./v2_7_2_full.yaml
kubectl apply -f ./add-ons/aws-load-balancer-controller-v2_7_2_full.yaml

# Install AWS Load Balancer Controller Ingclass https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.7.2/v2_7_2_ingclass.yaml
kubectl apply -f ./add-ons/aws-load-balancer-controller-v2_7_2_ingclass.yaml

```

aws eks describe-addon --cluster-name eks-on-fargate-cluster --addon-name kube-proxy --query addon.addonVersion --output text

kubectl set image daemonset.apps/kube-proxy -n kube-system kube-proxy=602401143452.dkr.ecr.ap-northeast-1.amazonaws.com/eks/kube-proxy:v1.30.0-minimal-eksbuild.3

kubectl rollout restart -n cert-manager deployment cert-manager
kubectl rollout restart -n kube-system deployment coredns

kubectl rollout restart -n cert-manager deployment cert-manager-cainjector
kubectl rollout restart -n cert-manager deployment cert-manager-webhook

kubectl rollout restart -n kube-system deployment aws-load-balancer-controller

eksctl create iamidentitymapping \
    --cluster $EKS_CLUSTER \
    --region=$AWS_REGION \
    --arn arn:aws:iam::$AWS_ACCOUNT_ID:user/ktou@dxc.com \
    --group eks-console-dashboard-full-access-group \
    --no-duplicate-arns