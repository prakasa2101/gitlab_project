output "external_dns_role_arn" {
  value = module.external_dns_role.iam_role_arn
}

output "lb_role_arn" {
  value = module.lb_role.iam_role_arn
}

output "identity_provider_arns" {
  value = {
    for providers, attributes in aws_iam_saml_provider.default : providers => attributes.arn
  }
}