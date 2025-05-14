resource "helm_release" "secrets_store_csi_driver" {
  name       = "secrets-store-csi-driver"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart      = "secrets-store-csi-driver"
  # version    = "1.5.0" # Replace with latest stable version

  set = [
    {
      name  = "enableSecretRotation"
      value = "true"
    },
    {
      name  = "rotationPollInterval"
      value = "30s"
    }
  ]
}

resource "helm_release" "aws_csi_secrets_provider" {
  name       = "secrets-provider-aws"
  namespace  = "kube-system"
  repository = "https://aws.github.io/secrets-store-csi-driver-provider-aws"
  chart      = "secrets-store-csi-driver-provider-aws"
  # version    = "1.0.1" # Optional: set to a known stable version or omit for latest
  depends_on = [
    helm_release.secrets_store_csi_driver
  ]
}

