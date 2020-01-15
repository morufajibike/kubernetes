resource "aws_iam_role" "demo-cluster" {
  name = "terraform-eks-demo-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "eks.amazonaws.com"
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "demo-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.demo-cluster.name
}

resource "aws_iam_role_policy_attachment" "demo-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.demo-cluster.name
}

output "aws_iam_role_demo_cluster_arn" {
  value = aws_iam_role.demo-cluster.arn
}

output "aws_iam_role_policy_attachment_demo_cluster_eksclusterpolicy" {
  value = aws_iam_role_policy_attachment.demo-cluster-AmazonEKSClusterPolicy
}

output "aws_iam_role_policy_attachment_demo_cluster_eksservicepolicy" {
  value = aws_iam_role_policy_attachment.demo-cluster-AmazonEKSServicePolicy
}
