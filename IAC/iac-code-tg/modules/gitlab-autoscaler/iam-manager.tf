resource "aws_iam_instance_profile" "gitlab_manager_instance_profile" {
  name = "opt-ct-GitLabManagerEC2InstanceProfile"
  role = aws_iam_role.gitlab_manager_iam_role.name
}

resource "aws_iam_role" "gitlab_manager_iam_role" {
  name = "opt-ct-gitlab-manager"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

### SSM Paremeters Inline Policy
resource "aws_iam_role_policy" "gitlab_runner_ssm_parameter_policy" {
  name   = "gitlab_runner_ssm_parameter_policy"
  role   = aws_iam_role.gitlab_manager_iam_role.id
  policy = data.aws_iam_policy_document.gitlab-runner-ssm-parameter-policy.json
}
data "aws_iam_policy_document" "gitlab-runner-ssm-parameter-policy" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:PutParameter",
      "ssm:GetParameters"
    ]
    resources = [
      "arn:${data.aws_partition.current.partition}:ssm:*:*:parameter/${var.secure_parameter_store_runner_token_key}"
    ]
  }

}

### SSM ManagedInstance - attached
resource "aws_iam_role_policy_attachment" "gitlab_ssm_policy_attachment" {
  role       = aws_iam_role.gitlab_manager_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

### ECR Access for GitlabManager
resource "aws_iam_role_policy_attachment" "gitlab_ecr_policy_attachment" {
  role       = aws_iam_role.gitlab_manager_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# ### Assume Terraform executor  role
# data "aws_iam_policy_document" "gitlab_manager_assume_role_policy" {

#   statement {
#     sid    = "allowAssumeRole"
#     effect = "Allow"

#     actions = [
#       "sts:AssumeRole"
#     ]
#     resources = [
#       "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/terraform-executor"
#     ]
#   }
# }
# resource "aws_iam_role_policy" "gitlab_manager_assume_role" {
#   name   = "gitlab_manager_assume_role_policy"
#   role   = aws_iam_role.gitlab_manager_iam_role.id
#   policy = data.aws_iam_policy_document.gitlab_manager_assume_role_policy.json
# }


### 
resource "aws_iam_role_policy" "gitlab_runner_manager_parameter_policy" {
  name   = "gitlab_manager_policy"
  role   = aws_iam_role.gitlab_manager_iam_role.id
  policy = data.aws_iam_policy_document.manager_policy_document.json
}
data "aws_iam_policy_document" "manager_policy_document" {
  statement {
    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup"
    ]
    effect    = "Allow"
    resources = [for asg in aws_autoscaling_group.gitlab_runner_autoscaling_group : asg.arn]
  }

  statement {
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "ec2:DescribeInstances"
    ]
    effect    = "Allow"
    resources = ["*"]
  }

  dynamic "statement" {
    for_each = var.manager_projects
    content {
      effect = "Allow"
      actions = [
        "ec2:GetPasswordData",
        "ec2-instance-connect:SendSSHPublicKey"
      ]
      resources = ["arn:aws:ec2:${var.region}:${data.aws_caller_identity.current.account_id}:instance/*"]

      condition {
        test     = "StringEquals"
        variable = "ec2:ResourceTag/aws:autoscaling:groupName"
        values   = ["opt-ct-Runner-ASG-${statement.value.project_name}"]
      }
    }
  }



}
