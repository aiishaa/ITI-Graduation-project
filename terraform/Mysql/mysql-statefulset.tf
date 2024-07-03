resource "kubernetes_secret" "mysql_secret" {
  metadata {
    name      = "mysql-secret"
    namespace = "dev"
  }

  data = {
    root-password = base64encode(var.mysql_root_password)
    user-password = base64encode(var.mysql_user_password)
    username      = base64encode(var.mysql_username)
    database-name = base64encode(var.mysql_database_name)
  }
}
ubuntu@ip-172-31-234-205:~/iti-project/terraform/Mysql$ ls
mysql-secret.tf  mysql-service.tf  mysql-statefulset.tf  variables.tf
ubuntu@ip-172-31-234-205:~/iti-project/terraform/Mysql$ cat mysql-service.tf 

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
ubuntu@ip-172-31-234-205:~/iti-project/terraform/Mysql$ cat variables.tf 
variable "mysql_root_password" {
  type        = string
  description = "The root password for MySQL."
  sensitive   = true
}

variable "mysql_user_password" {
  type        = string
  description = "The user password for MySQL."
  sensitive   = true
}

variable "mysql_username" {
  type        = string
  description = "The username for MySQL."
  sensitive   = true
}

variable "mysql_database_name" {
  type        = string
  description = "The database name for MySQL."
  sensitive   = true
}
ubuntu@ip-172-31-234-205:~/iti-project/terraform/Mysql$ cat mysql-statefulset.tf 
resource "kubernetes_stateful_set" "mysql" {
  metadata {
    name      = "mysql"
    namespace = "dev"
  }

  spec {
    service_name = "mysql"
    replicas     = 1

    selector {
      match_labels = {
        app = "mysql"
      }
    }

    template {
      metadata {
        labels = {
          app = "mysql"
        }
      }

      spec {
        container {
          name  = "mysql"
          image = "mysql:5.7"

          env {
            name = "MYSQL_ROOT_PASSWORD"

            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql_secret.metadata[0].name
                key  = "root-password"
              }
            }
          }

          env {
            name = "MYSQL_PASSWORD"

            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql_secret.metadata[0].name
                key  = "user-password"
              }
            }
          }

          env {
            name = "MYSQL_USER"

            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql_secret.metadata[0].name
                key  = "username"
              }
            }
          }

          env {
            name = "MYSQL_DATABASE"

            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql_secret.metadata[0].name
                key  = "database-name"
              }
            }
          }

          port {
            container_port = 3306
          }

          volume_mount {
            name       = "mysql-persistent-storage"
            mount_path = "/var/lib/mysql"
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "mysql-persistent-storage"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "1Gi"
          }
        }
      }
    }
  }
}
