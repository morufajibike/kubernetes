
module "secret_store_csi_driver" {
  source                     = "./secret-store-csi-driver"
  eks_cluster_name           = module.eks.cluster_name
  eks_cluster_endpoint       = module.eks.cluster_endpoint
  eks_cluster_ca_certificate = module.eks.cluster_certificate_authority_data
  account_id                = data.aws_caller_identity.current.account_id
  account_region            = data.aws_region.current.name
}
