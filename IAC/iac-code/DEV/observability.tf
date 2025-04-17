
locals {
  cloudwatch_log_groups = [
    "application",
    "dataplane",
    "performance"
  ]
}

# Performance Metrics LogGroup
resource "aws_cloudwatch_log_group" "eks_container_insights" {
  for_each = toset(local.cloudwatch_log_groups)


  name              = "/aws/containerinsights/${module.eks.cluster_name}/${each.key}"
  retention_in_days = var.metrics_logs_retention_in_days
  tags              = local.tags
  kms_key_id        = module.kms_keys["cloudwatch-logs"].arn


  # ONLY STANDARD as IA doesn't support metrics
  log_group_class = "STANDARD"
}
