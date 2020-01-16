#
# Workstation External IP
#
# This configuration is not required and is
# only provided as an example to easily fetch
# the external IP of your local workstation to
# configure inbound EC2 Security Group access
# to the Kubernetes cluster.
#

data "http" "workstation-external-ip" {
  url = "http://ipv4.icanhazip.com"
}

# Override with variable or hardcoded value if necessary
locals {
  workstation-external-cidr = "${chomp(data.http.workstation-external-ip.body)}/32"
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

  cluster_name        = var.cluster_name
  vpc_id              = module.networking.vpc_id
  workstation_ip_cidr = local.workstation-external-cidr
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
  subnet_ids             = module.networking.subnet_ids
  demo_node_iam_role_arn = module.iam_node.demo_node_iam_role_arn
  desired_size           = 1
  max_size               = 2
  min_size               = 1
  node_instance_type     = var.node_instance_type
  kubernetes_version     = var.kubernetes_version
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
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - ${var.cluster_name}
      env:
        - name: AWS_PROFILE
          value: prestaging

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
