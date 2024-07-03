resource "kubernetes_service" "nodejs" {
  metadata {
    name      = "nodejs"
    namespace = kubernetes_namespace.dev.metadata[0].name
  }

  spec {
    selector = {
      app = "nodejs"
    }

    port {
      port        = 3000
      target_port = 3000
      node_port   = 32005
    }

    type = "NodePort"
  }
}
