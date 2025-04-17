<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.8.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.48 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.7 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.30 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.48 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.7 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.30 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aurora"></a> [aurora](#module\_aurora) | terraform-aws-modules/rds-aurora/aws | n/a |
| <a name="module_cognito_custom_message"></a> [cognito\_custom\_message](#module\_cognito\_custom\_message) | terraform-aws-modules/lambda/aws | n/a |
| <a name="module_ecr_repositories"></a> [ecr\_repositories](#module\_ecr\_repositories) | ../tf-modules/ecr | n/a |
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 20.11.0 |
| <a name="module_eks_managed_node_group"></a> [eks\_managed\_node\_group](#module\_eks\_managed\_node\_group) | terraform-aws-modules/eks/aws//modules/eks-managed-node-group | 20.11.0 |
| <a name="module_external_dns_role"></a> [external\_dns\_role](#module\_external\_dns\_role) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | 4.17.1 |
| <a name="module_kms_keys"></a> [kms\_keys](#module\_kms\_keys) | ../tf-modules/kms | n/a |
| <a name="module_lb_role"></a> [lb\_role](#module\_lb\_role) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | 4.17.1 |
| <a name="module_opt_app_runner_dev"></a> [opt\_app\_runner\_dev](#module\_opt\_app\_runner\_dev) | ../tf-modules/gitlab_runner | n/a |
| <a name="module_opt_iac_runner_dev"></a> [opt\_iac\_runner\_dev](#module\_opt\_iac\_runner\_dev) | ../tf-modules/gitlab_runner | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.dns_name_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.dns_name_cert_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_cloudwatch_log_group.eks_container_insights](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cognito_user_group.patients](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_group) | resource |
| [aws_cognito_user_pool.userpool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool) | resource |
| [aws_cognito_user_pool_client.appclient](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client) | resource |
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_instance_profile.app_deployer_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.developer_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.devops_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.external_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.load_balancer_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.app-deployer-assume-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.app_deployer_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_route53_record.dns_name_cert_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.dns_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [helm_release.external-dns](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.lb_controller](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.secrets-store-csi-driver](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.secrets-store-csi-driver-provider-aws](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_cluster_role.gitlab_agent_reqs_cluster_role](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_namespace.namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_role_binding.app_group_gitlab_agent_rolebinding](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [kubernetes_service_account.external-dns](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [kubernetes_service_account.service-account](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster_auth.eks_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy_document.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_roles.AWSReservedSSO_AdministratorAccess](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_roles) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_rds_engine_version.aurora](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/rds_engine_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_administrator_roles"></a> [administrator\_roles](#input\_administrator\_roles) | List of Account Administrators | `list(string)` | n/a | yes |
| <a name="input_amazon_cloudwatch_observability_version"></a> [amazon\_cloudwatch\_observability\_version](#input\_amazon\_cloudwatch\_observability\_version) | EKS addon version for amazon-cloudwatch-observability | `string` | n/a | yes |
| <a name="input_app_opt_sandbox_principal_arn"></a> [app\_opt\_sandbox\_principal\_arn](#input\_app\_opt\_sandbox\_principal\_arn) | app-opt-sandbox user group role arn | `string` | n/a | yes |
| <a name="input_aurora_allow_major_version_upgrade"></a> [aurora\_allow\_major\_version\_upgrade](#input\_aurora\_allow\_major\_version\_upgrade) | Enable to allow major engine version upgrades when changing engine versions. Defaults to false | `bool` | `false` | no |
| <a name="input_aurora_auto_minor_version_upgrade"></a> [aurora\_auto\_minor\_version\_upgrade](#input\_aurora\_auto\_minor\_version\_upgrade) | Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window | `bool` | `true` | no |
| <a name="input_aurora_backup_retention_period"></a> [aurora\_backup\_retention\_period](#input\_aurora\_backup\_retention\_period) | Days to retain backups for | `string` | `"7"` | no |
| <a name="input_aurora_cluster_db_parameters"></a> [aurora\_cluster\_db\_parameters](#input\_aurora\_cluster\_db\_parameters) | n/a | `map(string)` | `{}` | no |
| <a name="input_aurora_engine"></a> [aurora\_engine](#input\_aurora\_engine) | ## ---------------- ## Aurora Postgresql Database | `string` | `null` | no |
| <a name="input_aurora_engine_mode"></a> [aurora\_engine\_mode](#input\_aurora\_engine\_mode) | n/a | `string` | `"provisioned"` | no |
| <a name="input_aurora_engine_version"></a> [aurora\_engine\_version](#input\_aurora\_engine\_version) | n/a | `string` | `null` | no |
| <a name="input_aurora_instance_class"></a> [aurora\_instance\_class](#input\_aurora\_instance\_class) | n/a | `string` | n/a | yes |
| <a name="input_aurora_is_serverless"></a> [aurora\_is\_serverless](#input\_aurora\_is\_serverless) | n/a | `bool` | `null` | no |
| <a name="input_aurora_preferred_backup_window"></a> [aurora\_preferred\_backup\_window](#input\_aurora\_preferred\_backup\_window) | Daily time range during which automated backups. Time in UTC | `string` | `"04:00-06:00"` | no |
| <a name="input_aurora_preferred_maintenance_window"></a> [aurora\_preferred\_maintenance\_window](#input\_aurora\_preferred\_maintenance\_window) | Weekly time range during which system maintenance can occur, in (UTC) | `string` | `"Mon:00:00-Mon:03:00"` | no |
| <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account) | AWS account id | `string` | n/a | yes |
| <a name="input_aws_lb_controller_helm_version"></a> [aws\_lb\_controller\_helm\_version](#input\_aws\_lb\_controller\_helm\_version) | Helm Chart version for aws-load-balancer-controller | `string` | n/a | yes |
| <a name="input_aws_lb_controller_image_tag"></a> [aws\_lb\_controller\_image\_tag](#input\_aws\_lb\_controller\_image\_tag) | Imgage tag version for aws-load-balancer-controller | `string` | n/a | yes |
| <a name="input_coredns_version"></a> [coredns\_version](#input\_coredns\_version) | EKS addon version for coredns | `string` | n/a | yes |
| <a name="input_database_subnets"></a> [database\_subnets](#input\_database\_subnets) | List of database subnets CIDR | `list(string)` | n/a | yes |
| <a name="input_dns_name"></a> [dns\_name](#input\_dns\_name) | DNS Zone name | `string` | n/a | yes |
| <a name="input_ecr_repositories"></a> [ecr\_repositories](#input\_ecr\_repositories) | Set of the repositories's names that should be created | `list(string)` | n/a | yes |
| <a name="input_eks_version"></a> [eks\_version](#input\_eks\_version) | EKS version | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Provider S3 bucket name to store backend | `string` | n/a | yes |
| <a name="input_external_dns_domains"></a> [external\_dns\_domains](#input\_external\_dns\_domains) | List of allowed domains for external-dns | `list(string)` | n/a | yes |
| <a name="input_external_dns_helm_version"></a> [external\_dns\_helm\_version](#input\_external\_dns\_helm\_version) | Helm Chart version for external-dns | `string` | n/a | yes |
| <a name="input_external_dns_image_tag"></a> [external\_dns\_image\_tag](#input\_external\_dns\_image\_tag) | Imgage tag version for external-dns | `string` | n/a | yes |
| <a name="input_force_flush_interval"></a> [force\_flush\_interval](#input\_force\_flush\_interval) | Logs flush interval | `number` | `60` | no |
| <a name="input_git_group"></a> [git\_group](#input\_git\_group) | Project name | `string` | `"opt Med Tech"` | no |
| <a name="input_git_repo"></a> [git\_repo](#input\_git\_repo) | Git repository | `string` | n/a | yes |
| <a name="input_iac_app"></a> [iac\_app](#input\_iac\_app) | IAC application | `string` | `"terraform"` | no |
| <a name="input_iac_mode"></a> [iac\_mode](#input\_iac\_mode) | IAC mode | `string` | `"auto"` | no |
| <a name="input_kms_keys"></a> [kms\_keys](#input\_kms\_keys) | Map of KMS keys | `map(any)` | n/a | yes |
| <a name="input_kube_proxy_version"></a> [kube\_proxy\_version](#input\_kube\_proxy\_version) | EKS addon version for kube-proxy | `string` | n/a | yes |
| <a name="input_managed_node_group"></a> [managed\_node\_group](#input\_managed\_node\_group) | n/a | <pre>object({<br>    instance_types             = optional(list(string), ["m6in.large", "m6i.large", "m5n.large"])<br>    ami_id                     = optional(string, "")<br>    ami_type                   = optional(string, "BOTTLEROCKET_x86_64")<br>    platform                   = optional(string, "bottlerocket")<br>    cluster_ip_family          = optional(string, "ipv4")<br>    max_unavailable_percentage = optional(number, 50)<br>    disk_size                  = optional(number, 50)<br>    min_size                   = optional(number, 1)<br>    max_size                   = optional(number, 2)<br>    desired_size               = optional(number, 1)<br>    schedules                  = optional(map(any), {})<br>  })</pre> | `{}` | no |
| <a name="input_metrics_logs_retention_in_days"></a> [metrics\_logs\_retention\_in\_days](#input\_metrics\_logs\_retention\_in\_days) | Number of days to keep metrics logs data | `number` | `30` | no |
| <a name="input_metrics_scrape_interval"></a> [metrics\_scrape\_interval](#input\_metrics\_scrape\_interval) | Metrics scrape interval via Cloudwatch | `number` | `60` | no |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | List of namespaces | `list(string)` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | List of private subnets CIDR | `list(string)` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name | `string` | n/a | yes |
| <a name="input_project_owner"></a> [project\_owner](#input\_project\_owner) | Project owner | `string` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | List of public subnets CIDR | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Provider S3 bucket name to store backend | `string` | `"us-east-1"` | no |
| <a name="input_secrets_store_csi_driver_helm_version"></a> [secrets\_store\_csi\_driver\_helm\_version](#input\_secrets\_store\_csi\_driver\_helm\_version) | Helm Chart version for secrets\_store\_csi\_driver | `string` | n/a | yes |
| <a name="input_secrets_store_csi_driver_provider_aws_helm_version"></a> [secrets\_store\_csi\_driver\_provider\_aws\_helm\_version](#input\_secrets\_store\_csi\_driver\_provider\_aws\_helm\_version) | Helm Chart version for secrets-store-csi-driver-provider-aws | `string` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | Cluster VPC primary CIDR block | `string` | n/a | yes |
| <a name="input_vpc_cni_version"></a> [vpc\_cni\_version](#input\_vpc\_cni\_version) | EKS addon version for vpc-cni | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_writer_endpoint"></a> [writer\_endpoint](#output\_writer\_endpoint) | n/a |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | n/a |
<!-- END_TF_DOCS -->