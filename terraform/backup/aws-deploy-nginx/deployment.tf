
resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "scalable-nginx-demo"
    labels = {
      App = "ScalableNginxDemo"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "ScalableNginxDemo"
      }
    }

    template {
      metadata {
        labels = {
          App = "ScalableNginxDemo"
        }
      }
      spec {
        container {
          image = "nginx:1.7.8"
          name  = "demo"

          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}
