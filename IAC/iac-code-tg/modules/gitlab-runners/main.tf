
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

module "opt_app_runner" {
  # source = "git::git@gitlab.com:opt-med-tech/iac/tf-modules.git//gitlab_runner"
  source = "../../../../../../../tf-modules/gitlab_runner"

  runner_name                    = "app-runner"
  enable_terraform_executor_role = false
  aws_region                     = var.region
  vpc_id                         = var.vpc_id
  subnet_ids_gitlab_runner       = var.private_subnets
  # vpc_id                         = data.terraform_remote_state.vpc.outputs.vpc_id
  # subnet_ids_gitlab_runner       = data.terraform_remote_state.vpc.outputs.private_subnets
  runner_ami_filter            = ["*ubuntu-jammy-22.04-amd64-server-*"]
  runner_ami_owner             = ["099720109477"]
  runner_instance_profile_name = aws_iam_instance_profile.app_deployer_instance_profile.name
  runner_instance_type         = var.runner_instance_type

  runner_min_size         = var.app_runner_min_size
  runner_max_size         = var.app_runner_max_size
  runner_desired_capacity = var.app_runner_desired_capacity

  gitlab_runner_registration_config = {

    #### To get access to parameter store all runners names must follow convention opt-ct-Runner-<runner name>

    config = [
      { "name" = "opt-ct-Runner-Template", "token" = "${var.init_token_app}", "tag_list" = "opt_ct_template_runner,${var.environment}", "locked_to_project" = "yes", "run_untagged" = "no", "maximum_timeout" = "3600", "runner_type" = "project_type", "project_id" = "57977973" },
      { "name" = "opt-ct-Runner-Frontend-${var.environment}", "token" = "${var.init_token_app}", "tag_list" = "opt_ct_frontend_runner,${var.environment}", "locked_to_project" = "yes", "run_untagged" = "no", "maximum_timeout" = "3600", "runner_type" = "project_type", "project_id" = "58695425" },
      { "name" = "opt-ct-Runner-Backend-${var.environment}", "token" = "${var.init_token_app}", "tag_list" = "opt_ct_backend_runner,${var.environment}", "locked_to_project" = "yes", "run_untagged" = "no", "maximum_timeout" = "3600", "runner_type" = "project_type", "project_id" = "58695282" }
    ],

    common = [
      { "url" = "https://gitlab.com", "concurrent" = "4", "image" = "ubuntu:22.04", "executor" = "docker" }
    ]
  }
}

