output "aws_ses_domain_identity_arn" {
  description = "The domain identity arn"
  value       = aws_ses_domain_identity.domain.arn
}

output "aws_ses_domain" {
  description = "The domain identity name"
  value       = aws_ses_domain_identity.domain.domain
}