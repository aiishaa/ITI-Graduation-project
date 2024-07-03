resource "kubernetes_secret" "nexus-cred" {
  metadata {
    name      = "nexus-cred"
    namespace = kubernetes_namespace.dev.metadata[0].name
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = base64encode(jsonencode({
      auths = {
        "${var.docker_server}" = {
          username = var.docker_username
          password = var.docker_password
          auth     = base64encode("${var.docker_username}:${var.docker_password}")
        }
      }
    }))
  }
}
