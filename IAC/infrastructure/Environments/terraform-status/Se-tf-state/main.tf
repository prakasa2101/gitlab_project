provider "aws" {
  region = var.region #"us-east-1" # Change to your desired AWS region
}

resource "aws_s3_bucket" "tf-state-bucket" {
  bucket = "${var.project}-${var.app}-${var.bucketname}"
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_dynamodb_table" "tf-lock-table" {
  name           = "${var.project}-${var.app}-${var.tablename}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_iam_policy" "tf-state-policy" {
  name        = "${var.project}-${var.app}-${var.iampolicy}"               #"tf-state-policy"
  description = "Policy for Terraform state"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject",
          "s3:DeleteObject",
        ],
        Effect   = "Allow",
        Resource = [
          aws_s3_bucket.tf-state-bucket.arn,
          "${aws_s3_bucket.tf-state-bucket.arn}/*",
        ],
      },
      {
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:UpdateItem",
        ],
        Effect   = "Allow",
        Resource = aws_dynamodb_table.tf-lock-table.arn,
      },
    ],
  })
}

resource "aws_iam_role" "tf-state-role" {
  name = "${var.project}-${var.app}-${var.iamrole}"                      # "tf-state-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_iam_policy_attachment" "tf-state-policy-attachment" {
  name = "${var.project}-${var.app}-${var.iampolicyattachment}"   #"tf-state-policy-attachment" # Provide a unique name for the policy attachment
  policy_arn = aws_iam_policy.tf-state-policy.arn
  roles      = [aws_iam_role.tf-state-role.name]
}


resource "aws_iam_instance_profile" "tf-state-instance-profile" {
  name = "${var.project}-${var.app}-${var.instanceprofilename}"            #tf_state_instance_profile
  role = aws_iam_role.tf-state-role.name
}

