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
$ VPC_ID=$(terraform output -raw vpc_id)
$ AWSLoadBalancerControllerIAMPolicyArn=$(terraform output -raw AWSLoadBalancerControllerIAMPolicyArn)

```

## Configure EKS
```sh
# update kube config
$ aws eks update-kubeconfig --name $EKS_CLUSTER --region $AWS_REGION

# wait status changes to running
$ kubectl get pods --all-namespaces

NAMESPACE     NAME                       READY   STATUS    RESTARTS   AGE
kube-system   coredns-5654d57f78-qpj7v   1/1     Running   0          12m
kube-system   coredns-5654d57f78-sxhrk   1/1     Running   0          12m
```

## Configure EKS without Terraform
```sh
# update kube config
$ aws eks update-kubeconfig --name $EKS_CLUSTER --region $AWS_REGION

# give aws console full access
$ kubectl apply -f https://s3.us-west-2.amazonaws.com/amazon-eks/docs/eks-console-full-access.yaml
# Map the IAM principal to the Kubernetes user or group in the aws-auth ConfigMap
$ eksctl create iamidentitymapping \
    --cluster $EKS_CLUSTER \
    --region=$AWS_REGION \
    --arn arn:aws:iam::$AWS_ACCOUNT_ID:user/test@test.com \
    --group eks-console-dashboard-full-access-group \
    --no-duplicate-arns

# remove the eks.amazonaws.com/compute-type : ec2 annotation from the CoreDNS Pods.
$ kubectl patch deployment coredns -n kube-system --type json \
    -p='[{"op": "remove", "path": "/spec/template/metadata/annotations/eks.amazonaws.com~1compute-type"}]'

# restart coredns
$ kubectl rollout restart -n kube-system deployment coredns
```

## Install the AWS Load Balancer Controller using Helm
```sh
# create iam service account
$ eksctl create iamserviceaccount \
  --cluster=$EKS_CLUSTER \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-role-arn arn:aws:iam::$AWS_ACCOUNT_ID:role/AmazonEKSLoadBalancerControllerRole \
  --override-existing-serviceaccounts \
  --approve

2024-08-16 02:18:02 [ℹ]  1 iamserviceaccount (kube-system/aws-load-balancer-controller) was included (based on the include/exclude rules)
2024-08-16 02:18:02 [!]  serviceaccounts that exist in Kubernetes will be excluded, use --override-existing-serviceaccounts to override
2024-08-16 02:18:02 [ℹ]  1 task: { create serviceaccount "kube-system/aws-load-balancer-controller" }
2024-08-16 02:18:02 [ℹ]  created serviceaccount "kube-system/aws-load-balancer-controller"

# install controller
$ helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=$EKS_CLUSTER \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=$AWS_REGION \
  --set vpcId=$VPC_ID

NAME: aws-load-balancer-controller
LAST DEPLOYED: Fri Aug 16 02:19:33 2024
NAMESPACE: kube-system
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
AWS Load Balancer controller installed!

# wait status changes to running
$ kubectl get pods --namespace kube-system

NAMESPACE     NAME                                            READY   STATUS    RESTARTS   AGE
kube-system   aws-load-balancer-controller-5c675ff97f-88b48   1/1     Running   0          3m54s
kube-system   aws-load-balancer-controller-5c675ff97f-xgq8r   1/1     Running   0          2m42s
kube-system   coredns-6fc69f74f4-6m7n4                        1/1     Running   0          3m54s
kube-system   coredns-6fc69f74f4-nm8tp                        1/1     Running   0          3m54s

```

## Deploy Application
```sh
# deploy
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.7.2/docs/examples/2048/2048_full.yaml

r-controller/v2.7.2/docs/examples/2048/2048_full.yaml
namespace/game-2048 created
deployment.apps/deployment-2048 created
service/service-2048 created
ingress.networking.k8s.io/ingress-2048 created

# check running status
$ kubectl get pods --all-namespaces

NAMESPACE     NAME                                            READY   STATUS    RESTARTS   AGE
game-2048     deployment-2048-85f8c7d69-4ksdm                 1/1     Running   0          13m
game-2048     deployment-2048-85f8c7d69-g5xb9                 1/1     Running   0          13m
game-2048     deployment-2048-85f8c7d69-hjqpx                 1/1     Running   0          13m
game-2048     deployment-2048-85f8c7d69-l4hsg                 1/1     Running   0          13m
game-2048     deployment-2048-85f8c7d69-vpcbz                 1/1     Running   0          13m
kube-system   aws-load-balancer-controller-7698854599-56g5b   1/1     Running   0          3m46s
kube-system   aws-load-balancer-controller-7698854599-mglsf   1/1     Running   0          2m30s
kube-system   coredns-6fc69f74f4-6m7n4                        1/1     Running   0          18m
kube-system   coredns-6fc69f74f4-nm8tp                        1/1     Running   0          18m

# check ALB url
kubectl get ingress/ingress-2048 -n game-2048
NAME           CLASS   HOSTS   ADDRESS                                                                        PORTS   AGE
ingress-2048   alb     *       k8s-game2048-ingress2-7091e59c20-2128500031.ap-northeast-1.elb.amazonaws.com   80      14m
```

## Troubleshooting
```sh
# show aws-load-balancer-controller logs
$ kubectl logs -f -n kube-system -l app.kubernetes.io/instance=aws-load-balancer-controller

# confirm aws-load-balancer-controller service account
$ kubectl describe deploy aws-load-balancer-controller -n kube-system | grep -i "Service Account"

```