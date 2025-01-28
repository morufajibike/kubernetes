/*
resource "helm_release" "aspnet" {
  name       = "aspnet-webapp"
  repository = "https://marketplace.azurecr.io/helm/v1/repo"
  chart      = "aspnet-core"

  ## to get a chat repo values, use:
  ## `helm show values <chart>`
  values = [
    file("${path.module}/vals/aspnet.yaml")
  ]

  set_sensitive {
    name  = "slack.token"
    value = var.slack_app_token
  }
}
*/
