data "aws_iam_policy_document" "lb-controller-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.oidc-provider.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.oidc-provider.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "lb-controller-role" {
  assume_role_policy = data.aws_iam_policy_document.lb-controller-assume-role-policy.json
  name               = "lb-controller-role"
}

resource "aws_iam_policy" "lb-controller-policy" {
  policy = file("./AWSLoadBalancerController.json")
  name   = "AWSLoadBalancerControllerPolicy"
}

resource "aws_iam_role_policy_attachment" "lb-controller-policy-attachment" {
  role       = aws_iam_role.lb-controller-role.name
  policy_arn = aws_iam_policy.lb-controller-policy.arn
}

output "lb-controller-role-arn" {
  value = aws_iam_role.lb-controller-role.arn
}
