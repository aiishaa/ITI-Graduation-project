resource "kubernetes_service" "nexus" {
  metadata {
    name = "nexus-service"
    labels = {
      app = "nexus"
    }
  }

  spec {
    selector = {
      app = "nexus"
    }

    port {
      port        = 8081
      target_port = 8081
    }

    type = "NodePort"
  }
}

