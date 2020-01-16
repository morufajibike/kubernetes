variable "cluster_name" {}
variable "node_group_name" {}
variable "subnet_ids" {}
variable "demo_node_iam_role_arn" {}
variable "desired_size" {}
variable "max_size" {}
variable "min_size" {}
variable "node_instance_type" {}
variable "kubernetes_version" {}

resource "aws_eks_node_group" "demo" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = var.demo_node_iam_role_arn
  subnet_ids      = var.subnet_ids

  instance_types = [var.node_instance_type]

  version = var.kubernetes_version

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  depends_on = [
    var.cluster_name,
    var.demo_node_iam_role_arn
  ]
}
