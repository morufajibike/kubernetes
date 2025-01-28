
resource "helm_release" "nginx" {
  name  = "nginx-app"
  chart = "${path.module}/../../../helm-charts/nginx"

  ## to get a chat repo values, use:
  ## `helm show values <chart>`
  values = [
    file("${path.module}/vals/nginx.yaml")
  ]
}
