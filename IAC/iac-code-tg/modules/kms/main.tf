module "kms_keys" {
  source = "../../../../../../../tf-modules/kms"

  for_each    = var.kms_keys
  description = each.value.description
  alias       = each.value.alias

  # Privileges
  services            = each.value.services
  administrator_roles = var.administrator_roles

  # Metadata
  region = var.region

}
