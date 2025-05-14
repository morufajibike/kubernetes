variable "account_id" {
  description = "AWS account ID"
  type        = string
}

variable "account_region" {
  description = "AWS account region"
  type        = string
}

variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "eks_cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  type        = string
}

variable "eks_cluster_ca_certificate" {
  description = "The CA certificate for the EKS cluster"
  type        = string
}
