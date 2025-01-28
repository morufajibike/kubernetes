data "terraform_remote_state" "eks" {
  backend = "local"
  config = {
    path = "../aws-eks-cluster-v2/terraform.tfstate"
  }
}

# Retrieve EKS cluster configuration
data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

