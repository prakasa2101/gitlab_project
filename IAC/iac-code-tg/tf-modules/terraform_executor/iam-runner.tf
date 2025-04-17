
### Gitlab Runner Role
resource "aws_iam_role" "gitlab_runner_role" {
  name               = var.gitlab_runner_role_name
  assume_role_policy = data.aws_iam_policy_document.ec2.json
}

# Create runner instance profile 
resource "aws_iam_instance_profile" "instance_profile" {
  name = var.gitlab_runner_role_name
  role = aws_iam_role.gitlab_runner_role.id
}


# Assume role policy for terraform executor
data "aws_iam_policy_document" "gitlab-runner-assume-role-policy" {

  statement {
    sid    = "allowAssumeRole"
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    resources = [
      aws_iam_role.terraform-executor-role.arn
    ]
  }
}
resource "aws_iam_role_policy" "gitlab_runner_assume_role" {
  name   = "gitlab_runner_assume_role_policy"
  role   = aws_iam_role.gitlab_runner_role.id
  policy = data.aws_iam_policy_document.gitlab-runner-assume-role-policy.json
}



### EC2 Assume Policy
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


# Policy for R/W access to runner ssm parameter store
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
resource "aws_iam_role_policy" "gitlab_runner_ssm_parameter_policy" {
  name   = "gitlab_runner_ssm_parameter_policy"
  role   = aws_iam_role.gitlab_runner_role.id
  policy = data.aws_iam_policy_document.gitlab-runner-ssm-parameter-policy.json
}



# Adding SSM policy to runner role (for console access and patch manager)
resource "aws_iam_role_policy_attachment" "runner-ssm-policy" {
  role       = aws_iam_role.gitlab_runner_role.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
}




