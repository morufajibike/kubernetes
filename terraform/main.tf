provider "aws" {
  region  = "us-east-1"
  profile = "prestaging"
}

module "identity_and_access" {
  source = "./iam"
}

module "networking" {
  source = "./vpc"

  cluster_name = var.cluster_name

}

module "eks_master" {
  source = "./eks/master"

  cluster_name = var.cluster_name
  vpc_id = module.networking.vpc_id 
  subnet_ids = module.networking.subnet_ids
  demo_node_iam_role_arn = module.identity_and_access.aws_iam_role_demo_node_arn 
}
