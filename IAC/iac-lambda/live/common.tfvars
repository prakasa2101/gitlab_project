##############################################################
### General project settings

project_name    = "opt-ct"
project_owner   = "john@optmedtech.com"
git_repo        = "opt-med-tech/iac/iac-lambda"
environment     = "dev"
region          = "us-east-1"
aws_account     = "123456789012"
s3_state_bucket = "opt-terraform-state-dev"

tags = {
  "environment"   = "dev"
  "project:owner" = "john@optmedtech.com"
  "project:name"  = "opt-ct"
  "git:repo"      = "opt-med-tech/iac/iac-lambda"
  "git:group"     = "opt Med Tech"
  "iac:mode"      = "auto"
  "iac:app"       = "terraform"
}

#############################################################

