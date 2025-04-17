### 
#   KMS module
###

locals {
  administrator_roles = concat(var.administrator_roles, ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/terraform-executor"])

  # Default KMS Policy
  default-ksm-statements = [
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
    },
    {
      Sid = "Allow access for Key Administrators"
      Action = [
        "kms:UpdatePrimaryRegion",
        "kms:UpdateKeyDescription",
        "kms:UpdateCustomKeyStore",
        "kms:UpdateAlias",
        "kms:UntagResource",
        "kms:TagResource",
        "kms:ScheduleKeyDeletion",
        "kms:RevokeGrant",
        "kms:PutKeyPolicy",
        "kms:ListRetirableGrants",
        "kms:ListResourceTags",
        "kms:ListKeys",
        "kms:ListKeyPolicies",
        "kms:ListGrants",
        "kms:ListAliases",
        "kms:GetPublicKey",
        "kms:GetParametersForImport",
        "kms:GetKeyRotationStatus",
        "kms:GetKeyPolicy",
        "kms:EnableKeyRotation",
        "kms:EnableKey",
        "kms:DisableKeyRotation",
        "kms:DisableKey",
        "kms:DescribeKey",
        "kms:DescribeCustomKeyStores",
        "kms:DeleteImportedKeyMaterial",
        "kms:DeleteCustomKeyStore",
        "kms:DeleteAlias",
        "kms:CreateKey",
        "kms:CreateCustomKeyStore",
        "kms:CreateAlias",
        "kms:CancelKeyDeletion"
      ]
      Effect   = "Allow"
      Resource = "arn:aws:kms:${var.region}:${data.aws_caller_identity.current.account_id}:key/*"
      Principal = {
        "AWS" = local.administrator_roles
      }
    }
  ]
}


resource "aws_kms_key" "this" {

  description             = var.description
  deletion_window_in_days = 30
  key_usage               = "ENCRYPT_DECRYPT"
  multi_region            = false
  enable_key_rotation     = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(local.default-ksm-statements, [
      {
        Sid = "Allow use of the key"
        Action = [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:kms:${var.region}:${data.aws_caller_identity.current.account_id}:key/*"
        Principal = {
          "AWS"     = concat(local.administrator_roles, var.additional_user_roles != null ? var.additional_user_roles : [])
          "Service" = var.services
        }
        Condition = var.condition != null ? var.condition : {
          Bool = {
            "kms:CallerAccount" : data.aws_caller_identity.current.account_id
          }
        }
      }
    ])
  })
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.alias}"
  target_key_id = aws_kms_key.this.key_id
}
