variable "cluster_name" {}
variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string) # || set(string)
}
variable "demo_cluster_iam_role_arn" {}
variable "demo_cluster_sg_ids" {}

resource "aws_eks_cluster" "demo" {
  name     = var.cluster_name
  role_arn = var.demo_cluster_iam_role_arn

  vpc_config {
    security_group_ids = var.demo_cluster_sg_ids
    subnet_ids         = var.subnet_ids
  }
}

output "demo_cluster_version" {
  value = aws_eks_cluster.demo.version
}

output "demo_cluster_endpoint" {
  value = aws_eks_cluster.demo.endpoint
}

output "demo_cluster_cert_auth_data" {
  value = aws_eks_cluster.demo.certificate_authority[0].data
}
