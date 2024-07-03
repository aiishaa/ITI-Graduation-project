resource "kubernetes_secret" "nexus-cred" {
  metadata {
    name      = "nexus-cred"
    namespace = "dev"
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${kubernetes_service.nexus.spec.0.cluster_ip}:8083" = {
          "username" = var.docker_username
          "password" = var.docker_password
          "auth"     = base64encode("${var.docker_username}:${var.docker_password}")
        }
      }
    })
  }
}
