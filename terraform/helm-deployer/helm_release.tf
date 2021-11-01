
resource "helm_release" "aspnet" {
  name       = "aspnet-webapp"
  repository = "https://marketplace.azurecr.io/helm/v1/repo"
  chart      = "aspnet-core"

  /*
  values = [
    file("${path.module}/kubewatch-values.yaml")
  ]

  set_sensitive {
    name  = "slack.token"
    value = var.slack_app_token
  }
  */
}
