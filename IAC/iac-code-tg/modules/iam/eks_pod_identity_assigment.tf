


####  opt_twist_rds_pod_identity_associations
#
#  Cluster "opt-ct" postgres 
#
#  Role name: rds_access
# 
resource "aws_eks_pod_identity_association" "opt_sandbox_association" {
  for_each = var.opt_twist_rds_pod_identity_associations

  cluster_name    = var.eks_cluster_name
  namespace       = each.value.namespace
  service_account = each.value.service_account
  role_arn        = aws_iam_role.rds_access.arn
}

####  opt_twist_rds_pod_identity_associations
#
#  Cluster "opt-ct" postgres 
#
#  Role name: rds_access
# 
resource "aws_eks_pod_identity_association" "ct-portal-data-etl-reporting-rds-access-role-association" {
  for_each = var.opt_twist_reporting_rds_pod_identity_associations

  cluster_name    = var.eks_cluster_name
  namespace       = each.value.namespace
  service_account = each.value.service_account
  role_arn        = aws_iam_role.ct-portal-data-etl-reporting-rds-access-role.arn
}


####  cognito_rds_pod_identity_associations
#
#  Cluster "opt-ct" postgres 
#  Cognito User Pool
#
#  Role name: cognito_rds_access
# 
resource "aws_eks_pod_identity_association" "cognito_rds_associations" {
  for_each = var.cognito_rds_pod_identity_associations

  cluster_name    = var.eks_cluster_name
  namespace       = each.value.namespace
  service_account = each.value.service_account
  role_arn        = aws_iam_role.cognito_rds_access.arn
}