# ECR creation Module
# requires map of ecr's to create

### ECR registry 
resource "aws_ecr_repository" "repository" {
  name = var.repository_name

  image_tag_mutability = "IMMUTABLE"
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}

### ECR Lifecycle policy
resource "aws_ecr_lifecycle_policy" "repository_maintenance_policy" {

  repository = aws_ecr_repository.repository.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire untagged older than 7 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 7
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 2,
            "description": "Expire tagged older than 30 days",
            "selection": {
                "tagStatus": "tagged",
                "tagPatternList": ["*.*"],
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 30
            },
            "action": {
                "type": "expire"
            }
        }        
    ]
}
EOF
}
resource "aws_ecr_repository_policy" "ecr_access_policy" {

  repository = aws_ecr_repository.repository.name
  policy     = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowWriteAccessToEcrToGitlabRunner",
            "Effect": "Allow",
            "Principal": {
              "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/terraform-executor"
            },
            "Action": [
              "ecr:*"
            ]
        },
        {
            "Sid": "AllowPull",
            "Effect": "Allow",
            "Principal": {
              "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": [
				"ecr:GetDownloadUrlForLayer",
				"ecr:BatchGetImage",
				"ecr:DescribeImages",
				"ecr:ListImages"
            ]
        }
    ]
}
EOF

}

