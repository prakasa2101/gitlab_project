# Gitlab agent cluster roles

resource "kubernetes_cluster_role" "gitlab_agent_reqs_cluster_role" {
  metadata {
    name = "gitlab-agent-reqs-role"
  }

  rule {
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
    verbs      = ["create", "delete", "deletecollection", "get", "list", "patch", "update", "watch"]
  }
}


resource "kubernetes_role_binding" "app_group_gitlab_agent_rolebinding" {
  for_each = toset(var.namespaces)
  metadata {
    name      = "${each.key}-gitlab-agent-reqs"
    namespace = each.key
    labels = {
      rbac = "development"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.gitlab_agent_reqs_cluster_role.metadata.0.name
  }

  subject {
    kind      = "Group"
    name      = each.key
    api_group = "rbac.authorization.k8s.io"
    namespace = each.key
  }
}

