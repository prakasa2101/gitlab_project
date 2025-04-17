### Caller identity
data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}


data "aws_eks_cluster_auth" "eks_auth" {
  name = module.eks.cluster_name
}

data "aws_iam_roles" "AWSReservedSSO_AdministratorAccess" {
  name_regex = "AWSReservedSSO_AdministratorAccess.*"
}
