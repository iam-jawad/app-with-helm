resource "aws_iam_role" "kubesystem-profile-role" {
  name = "kubesystem-profile-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "kubesystem-profile-policy-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.kubesystem-profile-role.name
}

resource "aws_eks_fargate_profile" "kubesystem-profile" {
  cluster_name           = aws_eks_cluster.cluster.name
  fargate_profile_name   = "kubesystem-profile"
  pod_execution_role_arn = aws_iam_role.kubesystem-profile-role.arn

  # These subnets must have the following resource tag: 
  # kubernetes.io/cluster/<CLUSTER_NAME>.
  subnet_ids = [
    aws_subnet.private-us-east-1b.id
  ]

  selector {
    namespace = "kube-system"
  }
}
