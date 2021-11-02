variable "cluster_name" {
  default = "terraform-eks-demo"
  type    = string
}

variable "node_group_name" {
  default = "demo"
}

variable "node_instance_type" {
  default = "t2.small"
}

variable "kubernetes_version" {
  default = "1.14"
}

variable "min_size" {
  default = 1
  type    = number
}

variable "max_size" {
  default = 2
  type    = number
}

variable "desired_size" {
  default = 2
  type    = number
}
