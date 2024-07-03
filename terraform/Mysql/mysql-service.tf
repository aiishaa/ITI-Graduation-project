
resource "kubernetes_service" "mysql" {
  metadata {
    name      = "mysql"
    namespace = kubernetes_namespace.dev.metadata[0].name
  }

  spec {
    port {
      port        = 3306
      target_port = 3306
    }
    cluster_ip = "None"
    selector = {
      app = "mysql"
    }
  }
}
