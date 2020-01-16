variable "cluster_name" {
  default = "terraform-eks-demo"
  type    = string
}

variable "node_instance_type" {
  default = "t2.micro"
}

variable "kubernetes_version" {
  default = "1.14"
}
