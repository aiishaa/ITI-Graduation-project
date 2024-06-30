resource "kubernetes_secret" "jenkins" {
  metadata {
   name      = "jenkins"
    namespace = "tools"
    annotations = {
      "kubernetes.io/service-account.name"      = "jenkins"
      "kubernetes.io/service-account.namespace" = "tools"
    }
}
  type = "kubernetes.io/service-account-token"
}

resource "kubernetes_service_account" "jenkins" {
  metadata {
   name      = "jenkins"
    namespace = "tools"
  }

  automount_service_account_token = true
}

resource "kubernetes_role" "jenkins_role" {
  metadata {
    name      = "jenkins-role"
    namespace = "dev"
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "statefulsets"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "services", "secrets"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
}

resource "kubernetes_role_binding" "jenkins_role_binding" {
  metadata {
    name      = "jenkins-role-binding"
    namespace = "dev"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "jenkins" # kubernetes_service_account.jenkins.metadata[0].name
    namespace = "tools" #kubernetes_service_account.jenkins.metadata[0].namespace
  }

  role_ref {
    kind      = "Role"
    name      = kubernetes_role.jenkins_role.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }
}
