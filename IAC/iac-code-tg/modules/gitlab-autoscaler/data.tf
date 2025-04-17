data "aws_caller_identity" "current" {}

data "aws_ami" "gitlab" {
  most_recent = "true"
  filter {
    name   = "name"
    values = ["${var.manager_ami_name_prefix}-*"]
  }
  owners = var.manager_ami_owner
}

data "aws_partition" "current" {}

