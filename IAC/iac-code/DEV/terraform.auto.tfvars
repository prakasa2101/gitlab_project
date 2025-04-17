##############################################################
### General project settings

project_name  = "opt-ct"
project_owner = "john@optmedtech.com"
git_repo      = "opt-med-tech/iac/iac-code"
environment   = "dev"
region        = "us-east-1"
aws_account   = "123456789012"

#############################################################

### VPC configuration
vpc_cidr         = "172.30.0.0/16"
private_subnets  = ["172.30.0.0/22", "172.30.4.0/22"]
public_subnets   = ["172.30.8.0/22", "172.30.12.0/22"]
database_subnets = ["172.30.16.0/22", "172.30.20.0/22"]

### DNS
dns_name = "dev.myctportal.com"

### EKS cluster configuration
eks_version                                        = "1.30"
coredns_version                                    = "v1.11.1-eksbuild.9"
kube_proxy_version                                 = "v1.30.0-eksbuild.3"
vpc_cni_version                                    = "v1.18.1-eksbuild.3"
amazon_cloudwatch_observability_version            = "v1.7.0-eksbuild.1"
aws_lb_controller_helm_version                     = "1.7.1"
aws_lb_controller_image_tag                        = "v2.7.1"
external_dns_helm_version                          = "v1.14.4"
external_dns_image_tag                             = "v0.14.1"
external_dns_domains                               = ["dev.myctportal.com"]
secrets_store_csi_driver_helm_version              = "1.4.3"
secrets_store_csi_driver_provider_aws_helm_version = "0.3.9"

### EKS Namespaces
app_opt_sandbox_principal_arn = "arn:aws:iam::123456789012:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_App-Dev-Sandbox_14d89f514b0e3335"

managed_node_group = {
  ami_id = "ami-024704be7ae2749ee"
}

### ECR  cluster configuration
ecr_repositories = [
  "gitlab_worker",
  "image_scanner"
]

### Kubernetes Namespaces
namespaces = [
  "ct-portal-frontend",
  "ct-portal-backend",
  "opt-sandbox"
]

### Account Administrators
administrator_roles = [
  "arn:aws:iam::123456789012:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AdministratorAccess_6fdc179f7b513ded"
]

### KMS keys to be prepared
kms_keys = {
  "cloudwatch-logs" = {
    description = "Cloudwatch encryption Key"
    services    = ["logs.us-east-1.amazonaws.com"]
    alias       = "logs"
  },
  "rds-aurora" = {
    description = "AuroraDB encryption Key"
    services    = ["rds.amazonaws.com"]
    alias       = "aurora"
  }
}


### Aurora PostgreSQL Database - Serverless V2 / Instance Type
aurora_engine         = "aurora-postgresql"
aurora_engine_version = "15.5"

aurora_is_serverless  = null
aurora_instance_class = "db.t4g.medium"

aurora_cluster_db_parameters       = {}
aurora_auto_minor_version_upgrade  = true
aurora_allow_major_version_upgrade = false