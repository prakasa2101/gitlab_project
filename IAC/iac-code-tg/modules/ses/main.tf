# SES Domain Identity
resource "aws_ses_domain_identity" "domain" {
  domain = var.dns_name
}

# SES Domain DKIM
resource "aws_ses_domain_dkim" "domain_dkim" {
  domain = var.dns_name
}

# SES Domain Mail From
resource "aws_ses_domain_mail_from" "mail_from" {
  domain                 = aws_ses_domain_identity.domain.domain
  mail_from_domain       = "mail.${var.dns_name}"
  behavior_on_mx_failure = "UseDefaultValue"
}

# Route 53 Verification Record
resource "aws_route53_record" "verification_record" {
  zone_id = var.zone_id
  name    = aws_ses_domain_identity.domain.verification_token
  type    = "TXT"
  ttl     = 300
  records = [aws_ses_domain_identity.domain.verification_token]
}

# Route 53 DKIM Records
resource "aws_route53_record" "amazonses_dkim_record" {
  count   = 3
  zone_id = var.zone_id
  name    = "${aws_ses_domain_dkim.domain_dkim.dkim_tokens[count.index]}._domainkey"
  type    = "CNAME"
  ttl     = "600"
  records = ["${aws_ses_domain_dkim.domain_dkim.dkim_tokens[count.index]}.dkim.amazonses.com"]
}

# Route 53 Mail From MX Record
resource "aws_route53_record" "mail_from_mx" {
  zone_id = var.zone_id
  name    = "mail.${var.dns_name}"
  type    = "MX"
  ttl     = 300
  records = ["10 feedback-smtp.${var.region}.amazonses.com"]
}

# Route 53 Mail From SPF Record
resource "aws_route53_record" "mail_from_spf" {
  zone_id = var.zone_id
  name    = "mail.${var.dns_name}"
  type    = "TXT"
  ttl     = 300
  records = ["v=spf1 include:amazonses.com -all"]
}
