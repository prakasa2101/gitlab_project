### Caller identity
data "aws_caller_identity" "current" {}

### KMS IAM policy
locals {
  statement = [
    {
      Sid = "Enable IAM policies"
      Action = [
        "kms:Verify",
        "kms:UpdatePrimaryRegion",
        "kms:UpdateKeyDescription",
        "kms:UpdateCustomKeyStore",
        "kms:UpdateAlias",
        "kms:UntagResource",
        "kms:Sign",
        "kms:ScheduleKeyDeletion",
        "kms:RevokeGrant",
        "kms:RetireGrant",
        "kms:ReplicateKey",
        "kms:ReEncryptTo",
        "kms:ReEncryptFrom",
        "kms:PutKeyPolicy",
        "kms:ListRetirableGrants",
        "kms:ListResourceTags",
        "kms:ListKeys",
        "kms:ListKeyPolicies",
        "kms:ListGrants",
        "kms:ListAliases",
        "kms:ImportKeyMaterial",
        "kms:GetPublicKey",
        "kms:GetParametersForImport",
        "kms:GetKeyRotationStatus",
        "kms:GetKeyPolicy",
        "kms:GenerateRandom",
        "kms:GenerateDataKeyWithoutPlaintext",
        "kms:GenerateDataKeyPairWithoutPlaintext",
        "kms:GenerateDataKeyPair",
        "kms:GenerateDataKey",
        "kms:Encrypt",
        "kms:EnableKeyRotation",
        "kms:EnableKey",
        "kms:DisconnectCustomKeyStore",
        "kms:DisableKeyRotation",
        "kms:DisableKey",
        "kms:DescribeKey",
        "kms:DescribeCustomKeyStores",
        "kms:DeleteImportedKeyMaterial",
        "kms:DeleteCustomKeyStore",
        "kms:DeleteAlias",
        "kms:Decrypt",
        "kms:CreateKey",
        "kms:CreateGrant",
        "kms:CreateCustomKeyStore",
        "kms:CreateAlias",
        "kms:ConnectCustomKeyStore",
        "kms:CancelKeyDeletion"
      ]
      Effect   = "Allow"
      Resource = "arn:aws:kms:${var.region}:${data.aws_caller_identity.current.account_id}:key/*"
      Principal = {
        "AWS" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      }
    }
  ]
}

### KMS key
resource "aws_kms_key" "tfstate_single_region" {
  description             = "tfstate-single-region-${var.region}"
  deletion_window_in_days = 30
  key_usage               = "ENCRYPT_DECRYPT"
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(local.statement, [
      {
        Sid = "Allow use of the key"
        Action = [
          "kms:ReEncryptTo",
          "kms:ReEncryptFrom",
          "kms:GenerateDataKeyWithoutPlaintext",
          "kms:GenerateDataKeyPairWithoutPlaintext",
          "kms:GenerateDataKeyPair",
          "kms:GenerateDataKey",
          "kms:Encrypt",
          "kms:DescribeKey",
          "kms:Decrypt"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:key/*"
        Principal = {
          "Service" = [
            "s3.amazonaws.com",
            "dynamodb.amazonaws.com"
          ]
        }
        Condition = {
          Bool = {
            "kms:CallerAccount" : "${data.aws_caller_identity.current.account_id}"
          }
        }
      }
    ])
  })
}


### KMS alias
resource "aws_kms_alias" "tfstate" {
  name          = "alias/tfstate"
  target_key_id = aws_kms_key.tfstate_single_region.key_id
}

### S3 Bucket
resource "aws_s3_bucket" "tf-state-bucket" {
  bucket = "opt-terraform-state-${var.environment}"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Description = "S3 bucket for Terraform State for ${var.environment}"
  }
}

### Enable verioning
resource "aws_s3_bucket_versioning" "state-bucket-versioning" {
  bucket = aws_s3_bucket.tf-state-bucket.id
  versioning_configuration {
    status      = "Enabled"
    mfa_delete  = "Disabled"
  }
}

### Enable server side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "state-bucket-encryption" {
  bucket = aws_s3_bucket.tf-state-bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.tfstate_single_region.arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

### Enable object level encryption
resource "aws_s3_bucket_policy" "enforce_object_level_encryption" {
  bucket = aws_s3_bucket.tf-state-bucket.id
  policy = jsonencode(
    {
      Version = "2012-10-17",
      Id      = "PutObjectPolicy",
      Statement = [
        {
          Sid       = "DenyIncorrectEncryptionHeader",
          Effect    = "Deny",
          Principal = "*",
          Action    = "s3:PutObject",
          Resource  = "arn:aws:s3:::${aws_s3_bucket.tf-state-bucket.id}/*",
          Condition = {
            StringNotEquals = {
              "s3:x-amz-server-side-encryption-aws-kms-key-id" = aws_kms_key.tfstate_single_region.arn
            }
          }
        },
        {
          Sid       = "DenyUnencryptedObjectUploads",
          Effect    = "Deny",
          Principal = "*",
          Action    = "s3:PutObject",
          Resource  = "arn:aws:s3:::${aws_s3_bucket.tf-state-bucket.id}/*",
          Condition = {
            Null = {
              "s3:x-amz-server-side-encryption" = "true"
            }
          }
        },
        {
          Sid = "AllowSSLRequestsOnly",
          Action = [
            "s3:*"
          ],
          Effect = "Deny",
          Resource = [
            "arn:aws:s3:::${aws_s3_bucket.tf-state-bucket.id}",
            "arn:aws:s3:::${aws_s3_bucket.tf-state-bucket.id}/*"
          ],
          Condition = {
            Bool = {
              "aws:SecureTransport" = "false"
            }
          },
          Principal = "*"
        }
      ]
    }
  )
}

### Setting bucket ownership
resource "aws_s3_bucket_ownership_controls" "state-bucket-ownership" {
  bucket = aws_s3_bucket.tf-state-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

### Setting bucket ACL
resource "aws_s3_bucket_acl" "state-bucket-acl" {
  depends_on = [aws_s3_bucket_ownership_controls.state-bucket-ownership]

  bucket = aws_s3_bucket.tf-state-bucket.id
  acl    = "private"
}

### State lock table
resource "aws_dynamodb_table" "tf-lock-table" {
  name           = "terraform-state-lock-${var.environment}"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
  
  tags = {
    Description = "DynamoDB Terraform State Lock Table for ${var.environment}"
  }
}
