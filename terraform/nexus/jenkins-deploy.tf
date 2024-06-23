resource "kubernetes_deployment" "jenkins" {
  metadata {
    name      = "jenkins-deploy"
    namespace = "tools"
    labels = {
      deploy = "jenkins"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "jenkins"
      }
    }
    template {
      metadata {
        labels = {
          app = "jenkins"
        }
      }
      spec {
        container {
          image = "jenkins/jenkins:lts"
          name  = "jenkins"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

