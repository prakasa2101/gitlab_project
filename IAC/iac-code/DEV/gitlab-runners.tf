### IAC Runner

module "opt_iac_runner_dev" {
  # source = "git::https://gitlab.com/opt-med-tech/iac/tf-modules.git//gitlab_runner"
  source = "../tf-modules/gitlab_runner"


  runner_name                    = "iac-runner"
  enable_terraform_executor_role = true
  aws_region                     = var.region
  vpc_id                         = module.vpc.vpc_id
  subnet_ids_gitlab_runner       = module.vpc.private_subnets
  runner_ami_filter              = ["*ubuntu-jammy-22.04-amd64-server-*"]
  runner_ami_owner               = ["099720109477"]
  runner_instance_profile_name   = "opt-ct-gitlab-runner"
  runner_instance_type           = "m5.large"

  gitlab_runner_registration_config = {

    #### To get access to parameter store all runners names must follow convention opt-ct-Runner-<runner name>

    config = [
      { "name" = "opt-ct-Runner-IAC-DEV", "token" = "put token here only for initial deployment", "tag_list" = "opt_ct_iac_runner,${var.environment}", "locked_to_project" = "yes", "run_untagged" = "no", "maximum_timeout" = "3600", "runner_type" = "project_type", "project_id" = "57593033" },
      { "name" = "opt-ct-Runner-Image-Bakery-DEV", "token" = "put token here only for initial deployment", "tag_list" = "opt_ct_bakery_runner,${var.environment}", "locked_to_project" = "yes", "run_untagged" = "no", "maximum_timeout" = "3600", "runner_type" = "project_type", "project_id" = "57593387" }
    ],

    common = [
      { "url" = "https://gitlab.com", "concurrent" = "4", "image" = "ubuntu:22.04", "executor" = "docker" }
    ]
  }
}

### APP runner
data "aws_iam_policy_document" "ec2" {

  statement {

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "app_deployer_role" {
  name               = "app_deployer_role_${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.ec2.json
}

# Application Deployer Role (AssumeRole)

resource "aws_iam_role" "app-deployer-assume-role" {
  name               = "app_deployer_assume_role_${var.environment}"
  assume_role_policy = <<-EOF
  {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "${aws_iam_role.app_deployer_role.arn}"
        ]
      },
      "Action": "sts:AssumeRole",
      "Condition": {}
    }
  ]
  }
  EOF
}

# Create runner instance profile

resource "aws_iam_instance_profile" "app_deployer_instance_profile" {
  name = "app_deployer_${var.environment}"
  role = aws_iam_role.app_deployer_role.id
}

module "opt_app_runner_dev" {
  # source = "git::git@gitlab.com:opt-med-tech/iac/tf-modules.git//gitlab_runner"
  source = "../tf-modules/gitlab_runner"

  runner_name                    = "app-runner"
  enable_terraform_executor_role = false
  aws_region                     = var.region
  vpc_id                         = module.vpc.vpc_id
  subnet_ids_gitlab_runner       = module.vpc.private_subnets
  runner_ami_filter              = ["*ubuntu-jammy-22.04-amd64-server-*"]
  runner_ami_owner               = ["099720109477"]
  runner_instance_profile_name   = aws_iam_instance_profile.app_deployer_instance_profile.name
  runner_instance_type           = "m5.large"

  gitlab_runner_registration_config = {

    #### To get access to parameter store all runners names must follow convention opt-ct-Runner-<runner name>

    config = [
      { "name" = "opt-ct-Runner-Template", "token" = "put token here only for initial deployment", "tag_list" = "opt_ct_template_runner,${var.environment}", "locked_to_project" = "yes", "run_untagged" = "no", "maximum_timeout" = "3600", "runner_type" = "project_type", "project_id" = "57977973" },
      { "name" = "opt-ct-Runner-Frontend-${var.environment}", "token" = "put token here only for initial deployment", "tag_list" = "opt_ct_frontend_runner,${var.environment}", "locked_to_project" = "yes", "run_untagged" = "no", "maximum_timeout" = "3600", "runner_type" = "project_type", "project_id" = "58695425" },
      { "name" = "opt-ct-Runner-Backend-${var.environment}", "token" = "put token here only for initial deployment", "tag_list" = "opt_ct_backend_runner,${var.environment}", "locked_to_project" = "yes", "run_untagged" = "no", "maximum_timeout" = "3600", "runner_type" = "project_type", "project_id" = "58695282" }
    ],

    common = [
      { "url" = "https://gitlab.com", "concurrent" = "4", "image" = "ubuntu:22.04", "executor" = "docker" }
    ]
  }
}


# Gitlab agent cluster roles

resource "kubernetes_cluster_role" "gitlab_agent_reqs_cluster_role" {
  metadata {
    name = "gitlab-agent-reqs-role"
  }

  rule {
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
    verbs      = ["create", "delete", "deletecollection", "get", "list", "patch", "update", "watch"]
  }
}

resource "kubernetes_role_binding" "app_group_gitlab_agent_rolebinding" {
  for_each = toset(var.namespaces)
  metadata {
    name      = "${each.key}-gitlab-agent-reqs"
    namespace = each.key
    labels = {
      rbac = "development"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.gitlab_agent_reqs_cluster_role.metadata.0.name
  }

  subject {
    kind      = "Group"
    name      = each.key
    api_group = "rbac.authorization.k8s.io"
    namespace = each.key
  }
}
