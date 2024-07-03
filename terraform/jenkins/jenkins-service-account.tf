#resource "kubernetes_secret" "jenkins-agent" {
#  metadata {
#    name      = "jenkins-agent"
#    namespace = "tools"
#    annotations = {
#      "kubernetes.io/service-account.name"      = "jenkins-agent"
#      "kubernetes.io/service-account.namespace" = "tools"
#    }
#  }
#  type = "kubernetes.io/service-account-token"
#}

#resource "kubernetes_secret" "jenkins-manager" {
#  metadata {
#    name      = "jenkins-manager"
#    namespace = "tools"
#    annotations = {
#      "kubernetes.io/service-account.name"      = "jenkins-manager"
#      "kubernetes.io/service-account.namespace" = "tools"
#    }
#  }
#  type = "kubernetes.io/service-account-token"
#}

resource "kubernetes_service_account" "jenkins_manager" {
  metadata {
    name      = "jenkins-manager"
    namespace = "tools"
  }
}

resource "kubernetes_service_account" "jenkins_agent" {
  metadata {
    name      = "jenkins-agent"
    namespace = "tools"
  }
}

resource "kubernetes_role" "jenkins_role" {
  metadata {
    name      = "jenkins-agent-role"
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

resource "kubernetes_role_binding" "jenkins_agent_role_binding" {
  metadata {
    name      = "jenkins-agent-role-binding"
    namespace = "dev"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "jenkins-agent-role"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "jenkins-agent"
    namespace = "tools"
  }
}

resource "kubernetes_role" "jenkins_manager_role" {
  metadata {
    name      = "jenkins-manager-role"
    namespace = "tools"
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
  rule {
    api_groups = [""]
    resources  = ["pods/exec"]
    verbs      = ["create", "delete", "get", "list", "patch", "update", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods/log"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_role_binding" "jenkins_manager_role_binding" {
  metadata {
    name      = "jenkins-manager-role-binding"
    namespace = "tools"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "jenkins-manager-role"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "jenkins-manager"
    namespace = "tools"
  }
}
