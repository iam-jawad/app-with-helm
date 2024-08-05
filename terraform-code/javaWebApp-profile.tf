resource "aws_eks_fargate_profile" "javaWebApp-profile" {
  cluster_name           = aws_eks_cluster.cluster.name
  fargate_profile_name   = "javaWebApp-profile"
  pod_execution_role_arn = aws_iam_role.kubesystem-profile-role.arn

  subnet_ids = [
    aws_subnet.private-az-1a.id,
    aws_subnet.private-az-1b.id
  ]

  selector {
    namespace = var.app_namespace
  }
}
