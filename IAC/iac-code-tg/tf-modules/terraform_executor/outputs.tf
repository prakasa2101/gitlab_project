output "terraform_executor_role_arn" {
  value = aws_iam_role.terraform-executor-role.arn
}