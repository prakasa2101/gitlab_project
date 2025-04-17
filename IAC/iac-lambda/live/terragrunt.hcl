################################################################################
# root terragrunt.hcl
################################################################################

# Terraform backend configuration
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    encrypt        = true
    kms_key_id     = "arn:aws:kms:us-east-1:123456789012:key/6205412a-9299-4a40-9f8e-bb1585e52909"
    region         = "us-east-1"
    bucket         = "opt-terraform-state-dev"
    dynamodb_table = "terraform-state-lock-dev"
    key            = "application_lambda/${path_relative_to_include()}/terraform.tfstate"
  }
}

# Teraform provider configuration - region where to deploy resources
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      "environment"   = "dev"
      "project:owner" = "john@optmedtech.com"
      "project:name"  = "opt-ct"
      "git:repo"      = "opt-med-tech/iac/iac-lambda"
      "git:group"     = "opt Med Tech"
      "iac:mode"      = "auto"
      "iac:app"       = "terraform"
    }
  }
}

EOF
}
