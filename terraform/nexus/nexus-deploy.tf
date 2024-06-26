resource "kubernetes_deployment" "nexus" {
  metadata {
    name      = "nexus-deploy"
    namespace = "tools"
    labels = {
      deploy = "nexus"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "nexus"
      }
    }
    template {
      metadata {
        labels = {
          app = "nexus"
        }
      }
      spec {
        container {
          image = "sonatype/nexus3"
          name  = "nexus"
          port {
            container_port = 8081
          }
        }
      }
    }
  }
}

