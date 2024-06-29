resource "kubernetes_service" "jenkins" {
  metadata {
    name      = "jenkins-service"
    namespace = "tools"
    labels = {
      app = "jenkins"
    }
  }

  spec {
    selector = {
      app = "jenkins"
    }

    port {
      port        = 8080
      target_port = 8080
      node_port   = 32003
    }

    type = "NodePort"
  }
}
