
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

  cluster_name        = var.cluster_name
  vpc_id              = module.networking.vpc_id
  workstation_ip_cidr = local.workstation-ip-cidr
}

module "eks_master" {
  source = "./eks/master"

  cluster_name              = var.cluster_name
  vpc_id                    = module.networking.vpc_id
  subnet_ids                = module.networking.subnet_ids
  demo_cluster_iam_role_arn = module.iam_master.aws_iam_role_demo_cluster_arn
  demo_cluster_sg_ids       = module.security.demo_cluster_sg_ids
}

module "eks_node" {
  source = "./eks/node"

  cluster_name           = var.cluster_name
  node_group_name        = var.node_group_name
  subnet_ids             = module.networking.subnet_ids
  demo_node_iam_role_arn = module.iam_node.demo_node_iam_role_arn
  desired_size           = var.desired_size
  max_size               = var.max_size
  min_size               = var.min_size
  node_instance_type     = var.node_instance_type
  kubernetes_version     = var.kubernetes_version
}
