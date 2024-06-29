resource "kubernetes_ingress_v1" "nexus" {
  metadata {
    name = "nexus"
    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "nginx.ingress.kubernetes.io/proxy-body-size"    = "0"
      "nginx.ingress.kubernetes.io/proxy-read-timeout" = "300"
      "nginx.ingress.kubernetes.io/proxy-send-timeout" = "300"
    }
    namespace = "tools"
  }
  spec {
    rule {
      host = "nexus.com"
      http {
        path {
          path = "/"
          backend {
            service {
              name = "nexus-service"
              port {
                number = 8081
              }
            }

          }
        }
      }
    }
    rule {
      host = "nexus-repo.com"
      http {
        path {
          path = "/"
          backend {
            service {
              name = "nexus-service"
              port {
                number = 8083
              }
            }
          }
        }
      }
    }
  }
}
