resource "aws_iam_role" "demo-node" {
  name = "terraform-eks-demo-node"

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

resource "aws_iam_role_policy_attachment" "demo-node-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.demo-node.name
}

resource "aws_iam_role_policy_attachment" "demo-node-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.demo-node.name
}

output "demo_node_iam_role_name" {
  value = aws_iam_role.demo-node.name
}

output "iam_role_policy_attachment_demo_node_eksclusterpolicy" {
  value = aws_iam_role_policy_attachment.demo-node-AmazonEKSClusterPolicy
}

output "iam_role_policy_attachment_demo_node_eksservicepolicy" {
  value = aws_iam_role_policy_attachment.demo-node-AmazonEKSServicePolicy
}
