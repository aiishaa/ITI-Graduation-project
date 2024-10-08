resource "kubernetes_persistent_volume" "jenkins_pv" {
  metadata {
    name = "jenkins-pv"
  }
  spec {
    capacity = {
      storage = "10Gi"
    }
    access_modes                     = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"

    persistent_volume_source {
      host_path {
        path = "/mnt/data/jenkins"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "jenkins_pvc" {
  metadata {
    name      = "jenkins-pvc"
    namespace = "tools"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }
}

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
        service_account_name = "jenkins-manager" #kubernetes_service_account.jenkins.metadata[0].name
        container {
          image = "aishafathy/jenkinswithdocker:v100"
          name  = "jenkins"
          port {
            container_port = 8080
            protocol       = "TCP"
            name           = "manager"
          }
          port {
            container_port = 50000
            protocol       = "TCP"
            name           = "jnlp"
          }

          volume_mount {
            name       = "docker-daemon"
            mount_path = "/var/run/docker.sock"
          }

          volume_mount {
            name       = "jenkins-storage"
            mount_path = "/var/jenkins_home"
          }
        }

        volume {
          name = "docker-daemon"

          host_path {
            path = "/var/run/docker.sock"
          }
        }

        volume {
          name = "jenkins-storage"

          persistent_volume_claim {
            claim_name = "jenkins-pvc"
          }
        }
      }
    }
  }
}
