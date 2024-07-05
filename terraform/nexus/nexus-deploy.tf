resource "kubernetes_persistent_volume" "nexus_pv" {
  metadata {
    name = "nexus-pv"
  }
  spec {
    capacity = {
      storage = "10Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    host_path {
      path = "/mnt/data/nexus"
    }
  }
}

resource "kubernetes_persistent_volume_claim" "nexus_pvc" {
  metadata {
    name      = "nexus-pvc"
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
          port {
            container_port = 8083
          }
          volume_mount {
            mount_path = "/nexus-data"
            name       = "nexus-storage"
          }
        }
        volume {
          name = "nexus-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.nexus_pvc.metadata[0].name
          }
        }
      }
    }
  }
}
