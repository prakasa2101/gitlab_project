
### Common Data 
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}



##
## --- Cognito IAM Role
##
##  Role name: cognito_rds_access
##  Access to Cognito User Pool and "opt-ct" postgres 

## --- Cognito access policy
data "aws_iam_policy_document" "cognito_access" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:cognito-idp:${var.region}:${data.aws_caller_identity.current.account_id}:userpool/${var.cognito_user_pool_id}"]
    actions = [
      "cognito-idp:AdminGetUser",
      "cognito-idp:List*",
      "cognito-idp:Describe*",
      "cognito-idp:Get*"
    ]
  }
}
resource "aws_iam_policy" "cognito_access" {
  name   = "cognito_access"
  policy = data.aws_iam_policy_document.cognito_access.json
}
resource "aws_iam_role" "cognito_rds_access" {
  name               = "pod_identity_cognito_rds_access_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
resource "aws_iam_role_policy_attachment" "cognito_access" {
  policy_arn = aws_iam_policy.cognito_access.arn
  role       = aws_iam_role.cognito_rds_access.name
}
resource "aws_iam_role_policy_attachment" "cognito_rds_access" {
  policy_arn = aws_iam_policy.rds_access.arn
  role       = aws_iam_role.cognito_rds_access.name
}
### --------------------------------


###
### --- RDS IAM Role "opt-ct" postgres 
###
###  Role name: rds_access
###
data "aws_iam_policy_document" "rds_access" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:rds-db:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:dbuser:${var.aurora_cluster_resource_ids["opt-ct"]}/postgres"]
    actions   = ["rds-db:connect"]
  }
}
resource "aws_iam_policy" "rds_access" {
  name   = "rds_access"
  policy = data.aws_iam_policy_document.rds_access.json
}
resource "aws_iam_role" "rds_access" {
  name               = "pod_identity_rds_access_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
resource "aws_iam_role_policy_attachment" "rds_access" {
  policy_arn = aws_iam_policy.rds_access.arn
  role       = aws_iam_role.rds_access.name
}
### --------------------------------



###
### --- RDS IAM Role "opt-ct-reporting" postgres 
###
###  Role name: ct-portal-data-etl-reporting-rds-access-role
###
data "aws_iam_policy_document" "ct-portal-data-etl-data-reporting-rds-access" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:rds-db:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:dbuser:${var.aurora_cluster_resource_ids["opt-ct-reporting"]}/postgres"]
    actions   = ["rds-db:connect"]
  }
}
resource "aws_iam_policy" "ct-portal-data-etl-reporting-rds-access-policy" {
  name   = "ct-portal-data-etl-reporting-rds-access-policy"
  policy = data.aws_iam_policy_document.ct-portal-data-etl-data-reporting-rds-access.json
}
resource "aws_iam_role" "ct-portal-data-etl-reporting-rds-access-role" {
  name               = "ct_portal_data_etl_reporting_rds_access-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
resource "aws_iam_role_policy_attachment" "ct-portal-data-etl-reporting-rds-access-policy-attach" {
  policy_arn = aws_iam_policy.ct-portal-data-etl-reporting-rds-access-policy.arn
  role       = aws_iam_role.ct-portal-data-etl-reporting-rds-access-role.name
}

