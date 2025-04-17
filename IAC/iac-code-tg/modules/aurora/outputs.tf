output "cluster_resource_ids" {
  value = {
    for k, v in module.aurora : k => v.cluster_resource_id
  }
}

output "cluster_arns" {
  value = {
    for k, v in module.aurora : k => v.cluster_arn
  }
}

