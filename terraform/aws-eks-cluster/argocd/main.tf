resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "5.46.0"
  create_namespace = true
  values = [
    file("${path.module}/values/argocd.yaml")
  ]
}