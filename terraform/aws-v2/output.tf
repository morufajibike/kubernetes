
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

output "demo_vpc_id" {
  value = module.networking.vpc_id
}

output "demo_cluster_name" {
  value = module.eks_master.demo_cluster_name
}

output "demo_cluster_endpoint" {
  value = module.eks_master.demo_cluster_endpoint
}

output "demo_cluster_version" {
  value = module.eks_master.demo_cluster_version
}

output "workstation_ip_cidr" {
  value = local.workstation-ip-cidr
}

output "kubeconfig" {
  value = local.kubeconfig
}

output "config_map_aws_auth" {
  value = local.config_map_aws_auth
}
