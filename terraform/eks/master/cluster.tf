variable "cluster_name" {}
variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string) # || set(string)
}
variable "demo_node_iam_role_arn" {}

resource "aws_security_group" "demo-cluster" {
  name        = "terraform-eks-demo-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-eks-demo"
  }
}

resource "aws_security_group_rule" "demo-cluster-ingress-workstation-https" {
  cidr_blocks       = ["86.87.88.80/32"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.demo-cluster.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_eks_cluster" "demo" {
  name = var.cluster_name
  role_arn = var.demo_node_iam_role_arn

  vpc_config {
    security_group_ids = [aws_security_group.demo-cluster.id]
    subnet_ids	       = var.subnet_ids
  }
}
