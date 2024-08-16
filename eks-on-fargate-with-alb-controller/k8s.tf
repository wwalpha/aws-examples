# ----------------------------------------------------------------------------------------------
# Kubernetes Cluster Role
# ----------------------------------------------------------------------------------------------
resource "kubernetes_cluster_role" "eks_console_dashboard_full_access" {
  metadata {
    name = "eks-console-dashboard-full-access-clusterrole"
  }

  rule {
    api_groups = [""]
    resources = [
      "nodes",
      "namespaces",
      "pods",
      "configmaps",
      "endpoints",
      "events",
      "limitranges",
      "persistentvolumeclaims",
      "podtemplates",
      "replicationcontrollers",
      "resourcequotas",
      "secrets",
      "serviceaccounts",
      "services"
    ]
    verbs = ["get", "list"]
  }

  rule {
    api_groups = ["apps"]
    resources = [
      "deployments",
      "daemonsets",
      "statefulsets",
      "replicasets",
    ]
    verbs = ["get", "list"]
  }

  rule {
    api_groups = ["batch"]
    resources = [
      "jobs",
      "cronjobs",
    ]
    verbs = ["get", "list"]
  }

  rule {
    api_groups = ["coordination.k8s.io"]
    resources = [
      "leases",
    ]
    verbs = ["get", "list"]
  }

  rule {
    api_groups = ["discovery.k8s.io"]
    resources = [
      "endpointslices",
    ]
    verbs = ["get", "list"]
  }

  rule {
    api_groups = ["events.k8s.io"]
    resources = [
      "events",
    ]
    verbs = ["get", "list"]
  }

  rule {
    api_groups = ["extensions"]
    resources = [
      "daemonsets",
      "deployments",
      "ingresses",
      "networkpolicies",
      "replicasets",
    ]
    verbs = ["get", "list"]
  }

  rule {
    api_groups = ["networking.k8s.io"]
    resources = [
      "ingresses", "networkpolicies"
    ]
    verbs = ["get", "list"]
  }

  rule {
    api_groups = ["policy"]
    resources = [
      "poddisruptionbudgets",
    ]
    verbs = ["get", "list"]
  }

  rule {
    api_groups = ["rbac.authorization.k8s.io"]
    resources = [
      "rolebindings", "roles"
    ]
    verbs = ["get", "list"]
  }

  rule {
    api_groups = ["storage.k8s.io"]
    resources = [
      "csistoragecapacities"
    ]
    verbs = ["get", "list"]
  }
}

# ----------------------------------------------------------------------------------------------
# Kubernetes Cluster Role Binding
# ----------------------------------------------------------------------------------------------
resource "kubernetes_cluster_role_binding" "eks_console_dashboard_full_access_binding" {
  metadata {
    name = "eks-console-dashboard-full-access-binding"
  }
  role_ref {
    kind      = "ClusterRole"
    name      = "eks-console-dashboard-full-access-clusterrole"
    api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind      = "Group"
    name      = "eks-console-dashboard-full-access-group"
    api_group = "rbac.authorization.k8s.io"
  }
}

# # ----------------------------------------------------------------------------------------------
# # Kubernetes Service Account
# # ----------------------------------------------------------------------------------------------
# resource "kubernetes_service_account" "aws_loadbalancer_controller" {
#   metadata {
#     name      = "aws-load-balancer-controller"
#     namespace = "kube-system"
#     annotations = {
#       "eks.amazonaws.com/role-arn" = aws_iam_role.eks_service_account.arn
#     }
#     labels = {
#       "app.kubernetes.io/component"  = "controller"
#       "app.kubernetes.io/name"       = "aws-load-balancer-controller"
#       "app.kubernetes.io/managed-by" = "terraform"
#     }
#   }
# }

# # ----------------------------------------------------------------------------------------------
# # aws-load-balancer-controller
# # helm search repo eks/aws-load-balancer-controller --versions
# # ----------------------------------------------------------------------------------------------
# resource "helm_release" "aws-load-balancer-controller" {
#   depends_on = [kubernetes_service_account.aws_loadbalancer_controller]
#   name       = "aws-load-balancer-controller"
#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"
#   version    = "1.7.2"
#   namespace  = "kube-system"

#   set {
#     name  = "clusterName"
#     value = local.cluster_name
#   }

#   set {
#     name  = "serviceAccount.create"
#     value = false
#   }

#   set {
#     name  = "serviceAccount.name"
#     value = "aws-load-balancer-controller"
#   }

#   set {
#     name  = "aws-region"
#     value = data.aws_region.this.name
#   }

#   set {
#     name  = "aws-vpc-id"
#     value = module.vpc.vpc_id
#   }

#   # set {
#   #   name  = "image.repository"
#   #   value = "602401143452.dkr.ecr.ap-northeast-1.amazonaws.com/amazon/aws-load-balancer-controller"
#   # }

#   # set {
#   #   name  = "image.tag"
#   #   value = "v2.7.2"
#   # }
# }
