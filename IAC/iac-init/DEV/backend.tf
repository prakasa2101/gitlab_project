terraform {
  backend "s3" { 
  bucket     = "opt-terraform-state-dev"
  region     = "us-east-1"
  key        = "iac-init/terraform.tfstate"
  encrypt    = "true" 
  kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/6205412a-9299-4a40-9f8e-bb1585e52909"
  }
}
