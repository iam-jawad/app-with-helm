resource "aws_eks_cluster" "cluster" {
  name     = "${var.cluster_name}"
  version  = var.cluster_version
  role_arn = aws_iam_role.eks-cluster-role.arn

  vpc_config {

    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]

    subnet_ids = [
      aws_subnet.private-az-1a.id,
      aws_subnet.private-az-1b.id,
      aws_subnet.public-az-1a.id,
      aws_subnet.public-az-1b.id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.amazon-eks-cluster-policy]
}