resource "helm_release" "lb-controller" {
  name = "lb-controller"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = var.lb_controller_helm_version

  set {
    name  = "clusterName"
    value = aws_eks_cluster.cluster.id
  }

  set {
    name  = "image.tag"
    value = var.lb_controller_img_tag
  }

  set {
    name  = "replicaCount"
    value = var.lb_controller_replicaCount
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.lb-controller-role.arn
  }

  # EKS Fargate specific
  set {
    name  = "region"
    value = var.region
  }

  set {
    name  = "vpcId"
    value = aws_vpc.demo-vpc.id
  }

  depends_on = [aws_eks_addon.coredns]
}
