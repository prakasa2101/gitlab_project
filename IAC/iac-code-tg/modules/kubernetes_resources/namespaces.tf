resource "kubernetes_namespace" "namespace" {
  for_each = toset(var.namespaces)
  metadata {
    name = each.key
    labels = {
      name = each.key
    }
  }
}

