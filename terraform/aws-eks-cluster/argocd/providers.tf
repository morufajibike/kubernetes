terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "3.0.0-pre1"
    }
  }
}

provider "helm" {
  kubernetes = {
    host                   = var.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(var.eks_cluster_ca_certificate)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
      command     = "aws"
    }
  }
}