data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_roles" "AWSReservedSSO_AdministratorAccess" {
  name_regex = "AWSReservedSSO_AdministratorAccess.*"
}

## EKS Clouwdwatch Observability schema
locals {
  eks_cluster_name            = "${var.project_name}-${var.environment}"
  cluster_security_group_name = "${var.project_name}-${var.environment}"
  eks_iam_role_name           = "${var.project_name}-${var.environment}"
  node_security_group_name    = "${var.project_name}-${var.environment}"

  cw_addon_config = jsonencode(
    {
      "agent" : {
        "config" : {
          "region" : "${var.region}",
          "logs" : {
            "metrics_collected" : {
              "app_signals" : {
                "metrics_collection_interval" : var.metrics_scrape_interval,
                "hosted_in" : "${local.eks_cluster_name}"
              },
              "kubernetes" : {
                "metrics_collection_interval" : var.metrics_scrape_interval,
                "cluster_name" : "${local.eks_cluster_name}",
                "enhanced_container_insights" : true
              }
            },
            "force_flush_interval" : var.force_flush_interval
          },
          "traces" : {
            "traces_collected" : {
              "app_signals" : {}
            }
          }
        }
      },
      "containerLogs" : {
        "enabled" : true
      }
    }
  )

  eks_pod_identity_agent_config = jsonencode(
    {
      "agent" : {
        "additionalArgs" : {
          "-b" : "169.254.170.23"
        }
      }
    }
  )

}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.11.0"

  vpc_id                             = var.vpc_id
  cluster_name                       = local.eks_cluster_name
  prefix_separator                   = ""
  iam_role_name                      = local.eks_iam_role_name
  cluster_security_group_name        = local.cluster_security_group_name
  cluster_security_group_description = "EKS cluster security group - ${local.cluster_security_group_name}."
  cluster_version                    = var.eks_version
  cluster_enabled_log_types          = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  subnet_ids                         = concat(var.public_subnets, var.private_subnets, var.database_subnets)

  cluster_endpoint_public_access           = true
  cluster_endpoint_private_access          = false
  enable_cluster_creator_admin_permissions = false

  access_entries = {

    app-opt-sandbox = {
      principal_arn = var.app_opt_sandbox_principal_arn
      type          = "STANDARD"
      policy_associations = {
        app-opt-sandbox = {
          policy_arn = "arn:${data.aws_partition.current.partition}:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            namespaces = var.namespaces
            type       = "namespace"
          }
        },
        cluster-viewer = {
          policy_arn = "arn:${data.aws_partition.current.partition}:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }

    terraform_executor = {
      principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/terraform-executor"
      type          = "STANDARD"
      policy_associations = {
        admin = {
          policy_arn = "arn:${data.aws_partition.current.partition}:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }

    AdministratorAccess = {
      principal_arn = one(data.aws_iam_roles.AWSReservedSSO_AdministratorAccess.arns)
      type          = "STANDARD"
      policy_associations = {
        admin = {
          policy_arn = "arn:${data.aws_partition.current.partition}:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }



  }

  cluster_addons = {
    coredns = {
      addon_version               = var.coredns_version
      resolve_conflicts_on_create = "OVERWRITE"
    }
    eks-pod-identity-agent = {
      addon_version               = var.eks_pod_identity_agent_version
      configuration_values        = local.eks_pod_identity_agent_config
      resolve_conflicts_on_create = "OVERWRITE"
    }
    kube-proxy = {
      addon_version               = var.kube_proxy_version
      resolve_conflicts_on_create = "OVERWRITE"
    }
    vpc-cni = {
      addon_version               = var.vpc_cni_version
      resolve_conflicts_on_create = "OVERWRITE"
    }

    amazon-cloudwatch-observability = {
      addon_version               = var.amazon_cloudwatch_observability_version
      resolve_conflicts_on_create = "OVERWRITE"
      configuration_values        = local.cw_addon_config
    }

  }

  create_kms_key                  = true
  enable_kms_key_rotation         = true
  kms_key_administrators          = [one(data.aws_iam_roles.AWSReservedSSO_AdministratorAccess.arns), "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/terraform-executor"]
  kms_key_description             = "KMS Secrets encryption for ${local.eks_cluster_name} cluster."
  kms_key_enable_default_policy   = true
  kms_key_deletion_window_in_days = 30
  cluster_encryption_config = {
    resources = ["secrets"]
  }

  create_node_security_group                   = true
  node_security_group_name                     = "${local.node_security_group_name}-node-security-group"
  node_security_group_use_name_prefix          = true
  node_security_group_enable_recommended_rules = true
  node_security_group_tags = {
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "owned"
  }
}
