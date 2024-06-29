resource "kubernetes_service" "jenkins" {
  metadata {
    name      = "jenkins-service"
    namespace = "tools"
    labels = {
      app = "jenkins"
    }
  }

  spec {
    selector = {
      app = "jenkins"
    }

    port {
      port        = 8080
      target_port = 8080
      node_port   = 32003
    }

    type = "NodePort"
  }
}
ubuntu@ip-172-31-234-205:~/ITI-grad-project/terraform/jenkins$ cat jenkins-service-account.tf 
#resource "kubernetes_secret" "jenkins" {
#  metadata {
#   name      = "jenkins"
#    namespace = "tools"
#    annotations = {
#      "kubernetes.io/service-account.name"      = "jenkins"
#      "kubernetes.io/service-account.namespace" = "tools"
#    }
#}
#  type = "kubernetes.io/service-account-token"
#}

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
    api_groups = [""]
    resources  = ["pods", "services", "secrets"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "statefulsets"]
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
    name      = kubernetes_service_account.jenkins.metadata[0].name
    namespace = kubernetes_service_account.jenkins.metadata[0].namespace
  }

  role_ref {
    kind      = "Role"
    name      = kubernetes_role.jenkins_role.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_cluster_role" "jenkins" {
  metadata {
    name = "jenkins"
  }
  rule {
    api_groups = ["*"]
    resources = ["*"]
    verbs = ["*"]
  }
}

resource "kubernetes_cluster_role_binding" "jenkins" {
  metadata {
    name = "jenkins"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = "jenkins"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "jenkins"
    namespace = "tools"
  }
}
