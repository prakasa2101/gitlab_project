
###
# Enable Terraform Executor and Gitlab Runner roles and Policies
###
module "terraform_executor" {

  source = "../../../../../../../tf-modules/terraform_executor"

  count                                   = var.enable_terraform_executor_role ? 1 : 0
  gitlab_runner_role_name                 = var.runner_instance_profile_name
  secure_parameter_store_runner_token_key = var.secure_parameter_store_runner_token_key
}
