resource "aws_iam_saml_provider" "default" {
  for_each               = toset(var.identity_providers)
  name                   = each.key
  saml_metadata_document = file("identity_provider_metadata/${each.key}-saml-metadata.xml")
}