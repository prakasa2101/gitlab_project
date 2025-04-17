module "eks_managed_node_group" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "20.11.0"

  //  A node group per AZ works better with cluster autoscaler.
  for_each             = toset(module.vpc.private_subnets)
  name                 = "${var.project_name}-${var.environment}-${index(module.vpc.private_subnets, each.key)}"
  use_name_prefix      = true
  iam_role_name        = "${var.project_name}-${var.environment}-${index(module.vpc.private_subnets, each.key)}"
  cluster_name         = "${var.project_name}-${var.environment}"
  cluster_version      = var.eks_version
  cluster_endpoint     = module.eks.cluster_endpoint
  cluster_auth_base64  = module.eks.cluster_certificate_authority_data
  cluster_service_cidr = module.eks.cluster_service_cidr

  subnet_ids = [each.value]

  vpc_security_group_ids = [module.eks.node_security_group_id]

  use_custom_launch_template             = true
  launch_template_name                   = "${var.project_name}-${var.environment}-${each.value}"
  launch_template_use_name_prefix        = true
  update_launch_template_default_version = true

  instance_types             = var.managed_node_group.instance_types
  ami_id                     = var.managed_node_group.ami_id
  ami_type                   = var.managed_node_group.ami_type
  platform                   = var.managed_node_group.platform
  cluster_ip_family          = var.managed_node_group.cluster_ip_family
  min_size                   = var.managed_node_group.min_size
  max_size                   = var.managed_node_group.max_size
  desired_size               = var.managed_node_group.desired_size
  create_schedule            = var.managed_node_group.schedules != {} ? true : false
  schedules                  = var.managed_node_group.schedules
  enable_bootstrap_user_data = true

  #EKS observability
  iam_role_additional_policies = {
    "CloudWatchAgentAdminPolicy"   = "arn:aws:iam::aws:policy/CloudWatchAgentAdminPolicy"
    "CloudWatchLogsReadOnlyAccess" = "arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess"
    "CloudWatchAgentServerPolicy"  = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
    "AWSXrayWriteOnlyAccess"       = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
  }

  update_config = {
    max_unavailable_percentage = var.managed_node_group.max_unavailable_percentage
  }

  tags = merge(local.tags, {
    "autoscaling_group"    = "${var.project_name}-${var.environment}-${index(module.vpc.private_subnets, each.key)}"
    "autoscalinggroupname" = "${var.project_name}-${var.environment}-${index(module.vpc.private_subnets, each.key)}"
  })

  launch_template_tags = merge(local.tags, {
    "autoscaling_group"    = "${var.project_name}-${var.environment}-${index(module.vpc.private_subnets, each.key)}"
    "autoscalinggroupname" = "${var.project_name}-${var.environment}-${index(module.vpc.private_subnets, each.key)}"
  })

  block_device_mappings = {
    xvda = {
      device_name = "/dev/xvda"
      ebs = {
        volume_size           = 2
        volume_type           = "gp3"
        iops                  = 3000
        throughput            = 150
        encrypted             = true
        delete_on_termination = true
      }
    }
    xvdb = {
      device_name = "/dev/xvdb"
      ebs = {
        volume_size           = var.managed_node_group.disk_size
        volume_type           = "gp3"
        iops                  = 3000
        throughput            = 150
        encrypted             = true
        delete_on_termination = true
      }
    }
  }
}

locals {
  tags = {
    "k8s.io/cluster-autoscaler/enabled"                                = "true"
    "k8s.io/cluster-autoscaler/${var.project_name}-${var.environment}" = "true"
  }
}
