# Get current partition

data "aws_partition" "current" {}

# Terraform Provider Execution Role (AssumeRole)

resource "aws_iam_role" "terraform-executor-role" {
  name               = var.terraform_executor_role_name
  assume_role_policy = <<-EOF
  {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "${aws_iam_role.gitlab_runner_role.arn}"
        ]
      },
      "Action": "sts:AssumeRole",
      "Condition": {}
    }
  ]
  }
  EOF
}


### Adding Global Admin
resource "aws_iam_role_policy_attachment" "AdministratorAccess" {
  role       = aws_iam_role.terraform-executor-role.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AdministratorAccess"
}



#Terraform executor role policies

# Adding ECR Read/Write Access policy
# data "aws_iam_policy_document" "ecr-access-policy" {
#   statement {
#     sid    = "ECRPublic"
#     effect = "Allow"
#     actions = [
#       "ecr-public:GetAuthorizationToken",
#       "sts:GetServiceBearerToken",
#       "ecr-public:BatchCheckLayerAvailability",
#       "ecr-public:GetRepositoryPolicy",
#       "ecr-public:DescribeRepositories",
#       "ecr-public:DescribeRegistries",
#       "ecr-public:DescribeImages",
#       "ecr-public:DescribeImageTags",
#       "ecr-public:GetRepositoryCatalogData",
#       "ecr-public:GetRegistryCatalogData"
#     ]
#     resources = [
#       "*"
#     ]
#   }
#   statement {
#     sid    = "ECRPrivate"
#     effect = "Allow"
#     actions = [
#       "ecr:*",
#     ]
#     resources = ["*"]
#   }
# }
# resource "aws_iam_role_policy" "ecr-policy" {
#   name   = "AmazonContainerRegistryAccess"
#   role   = aws_iam_role.terraform-executor-role.id
#   policy = data.aws_iam_policy_document.ecr-access-policy.json
# }


# # Adding SecretManagerReadWrite Policy

# resource "aws_iam_role_policy_attachment" "secret-manager-policy" {
#   role       = aws_iam_role.terraform-executor-role.name
#   policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/SecretsManagerReadWrite"
# }

# # Adding AWS Lambda Policy

# resource "aws_iam_role_policy_attachment" "lambda-policy" {
#   role       = aws_iam_role.terraform-executor-role.name
#   policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AWSLambda_FullAccess"
# }

# # Adding SNS Policy

# resource "aws_iam_role_policy_attachment" "AmazonSNS-ReadOnlyAccess-policy" {
#   role       = aws_iam_role.terraform-executor-role.name
#   policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSNSReadOnlyAccess"
# }

# # Adding Route53 Policy

# resource "aws_iam_role_policy_attachment" "AmazonRoute53FullAccess" {
#   role       = aws_iam_role.terraform-executor-role.name
#   policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonRoute53FullAccess"
# }

# # Adding RDS Policy
# resource "aws_iam_role_policy_attachment" "AmazonRDSFullAccess" {
#   role       = aws_iam_role.terraform-executor-role.name
#   policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonRDSFullAccess"
# }

# # Addin IAM Admin Policy
# resource "aws_iam_role_policy_attachment" "IAMFullAccess" {
#   role       = aws_iam_role.terraform-executor-role.name
#   policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/IAMFullAccess"
# }

# # Adding EKS 
# resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
#   role       = aws_iam_role.terraform-executor-role.name
#   policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSWorkerNodePolicy"
# }

# # Adding S3 Policy
# resource "aws_iam_role_policy_attachment" "AmazonS3FullAccess" {
#   role       = aws_iam_role.terraform-executor-role.name
#   policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonS3FullAccess"
# }

# #Adding EC2
# resource "aws_iam_role_policy_attachment" "AmazonEC2FullAccess" {
#   role       = aws_iam_role.terraform-executor-role.name
#   policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEC2FullAccess"
# }

# # Adding ECR Policy

# resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
#   role       = aws_iam_role.terraform-executor-role.name
#   policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
# }

# # Adding KMS Admin Policy
# resource "aws_iam_role_policy_attachment" "AWSKeyManagementServicePowerUser" {
#   role       = aws_iam_role.terraform-executor-role.name
#   policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AWSKeyManagementServicePowerUser"
# }


