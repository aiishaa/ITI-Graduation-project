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
      name        = "manager"
      port        = 8080
      target_port = 8080
      node_port   = 32003
    }
    port {
      port        = 50000
      target_port = 50000
      node_port   = 32006
      protocol    = "TCP"
      name        = "agent"
    }

    type = "NodePort"
  }
}
