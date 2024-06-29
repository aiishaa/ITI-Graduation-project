resource "kubernetes_service" "nexus" {
  metadata {
    name      = "nexus-service"
    namespace = "tools"
    labels = {
      app = "nexus"
    }
  }

  spec {
    selector = {
      app = "nexus"
    }

    port {
      name        = "nexus"
      port        = 8081
      target_port = 8081
      node_port   = 32000
    }

    port {
      name        = "repo"
      port        = 8083
      target_port = 8083
      node_port   = 32001
    }
    type = "NodePort"
  }
}


