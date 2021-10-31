data "terraform_remote_state" "eks" {
  backend = "local"

  config = {
    path = "../aws-eks-cluster/terraform.tfstate"
  }
}

data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}
