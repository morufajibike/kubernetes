provider "aws" {
  region  = "us-east-1"
  profile = "cloud_sandbox"
  #access_key = "AKIAQTOLBFERFVT7FFE4"
  #secret_key = "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"
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
  demo_node_instance_profile_name     = module.iam_node.demo_node_instance_profile_name
  demo_node_sg_ids            = module.security.demo_node_sg_ids
  desired_capacity            = 2
  max_size                    = 2
  min_size                    = 1
  subnet_ids                  = module.networking.subnet_ids
}

locals {
  kubeconfig = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    server: ${module.eks_master.demo_cluster_endpoint}
    server: ${module.eks_master.demo_cluster_endpoint}
    certificate-authority-data: ${module.eks_master.demo_cluster_cert_auth_data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws
      args:
        - "--region"
        - "us-east-1"
        - "eks"
        - "get-token"
        - "--cluster-name"
        - var.cluster_name
      env:
        - name: AWS_PROFILE
          value: cloud_sandbox

KUBECONFIG
}

output "kubeconfig" {
  value = "${local.kubeconfig}"
}

## - Run terraform output config_map_aws_auth and save the configuration into a file e.g
## config_map_aws_auth.yaml
## - Run kubectl apply -f config_map_aws_auth.yaml
## - Verify nodes are joining the cluster: kubectl get nodes --watch

locals {
  config_map_aws_auth = <<CONFIGMAPAWSAUTH


apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${module.iam_node.demo_node_iam_role_arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH

}

output "config_map_aws_auth" {
  value = local.config_map_aws_auth
}
