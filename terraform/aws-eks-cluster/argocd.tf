module "argocd" {
  source                     = "./argocd"
  eks_cluster_name           = module.eks.cluster_name
  eks_cluster_endpoint       = module.eks.cluster_endpoint
  eks_cluster_ca_certificate = module.eks.cluster_certificate_authority_data
}