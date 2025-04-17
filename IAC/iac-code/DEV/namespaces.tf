resource "kubernetes_namespace" "namespace" {
  depends_on = [module.eks.cluster_endpoint]

  for_each = toset(var.namespaces)
  metadata {
    name = each.key
    labels = {
      name = each.key
    }
  }
}
