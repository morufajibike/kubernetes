provider "aws" {
  region  = "us-east-1"
  profile = "prestaging"
}

module "iam_master" {
  source = "./iam/master"
}

module "iam_node" {
  source = "./iam/node"
}

module "networking" {
  source = "./vpc"

  cluster_name = var.cluster_name

}

module "security" {
  source = "./security"

  cluster_name = var.cluster_name
  vpc_id       = module.networking.vpc_id
}

module "eks_master" {
  source = "./eks/master"

  cluster_name              = var.cluster_name
  vpc_id                    = module.networking.vpc_id
  subnet_ids                = module.networking.subnet_ids
  demo_cluster_iam_role_arn = module.iam_master.aws_iam_role_demo_cluster_arn
  demo_cluster_sg_ids       = module.security.demo_cluster_sg_ids
}

module "scaling" {
  source = "./scaling"

  cluster_name                = var.cluster_name
  demo_cluster_version        = module.eks_master.demo_cluster_version
  demo_cluster_endpoint       = module.eks_master.demo_cluster_endpoint
  demo_cluster_cert_auth_data = module.eks_master.demo_cluster_cert_auth_data
  launch_config_instance_type = "t2.medium" # m4.large
  demo_node_iam_role_name     = module.iam_node.demo_node_iam_role_name
  demo_node_sg_ids            = module.security.demo_node_sg_ids
  desired_capacity            = 2
  max_size                    = 2
  min_size                    = 1
  subnet_ids                  = module.networking.subnet_ids
}

