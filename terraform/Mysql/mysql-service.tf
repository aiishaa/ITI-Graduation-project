resource "kubernetes_service" "mysql" {
  metadata {
    name      = "mysql"
    namespace = "dev"
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
