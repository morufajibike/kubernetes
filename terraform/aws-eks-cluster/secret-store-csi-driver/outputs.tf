output "oidc_provider_arn" {
  value = data.aws_iam_openid_connect_provider.this.arn
}

output "eks_cluster_oidc_issuer" {
  value = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}
