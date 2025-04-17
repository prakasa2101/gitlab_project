resource "aws_route53_zone" "dns_name" {
  name = var.dns_name
}

resource "aws_acm_certificate" "dns_name_cert" {
  domain_name               = "*.${var.dns_name}"
  validation_method         = "DNS"
  subject_alternative_names = [var.dns_name]

  lifecycle {
    create_before_destroy = true
  }
}

# Deduplicate validation options
locals {
  unique_validation_options = distinct([for dvo in aws_acm_certificate.dns_name_cert.domain_validation_options : {
    name   = dvo.resource_record_name
    record = dvo.resource_record_value
    type   = dvo.resource_record_type
  }])
}

resource "aws_route53_record" "dns_name_cert_validation" {
  for_each = {
    for record in local.unique_validation_options : record.name => record
  }

  zone_id = aws_route53_zone.dns_name.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [records]
  }
}

resource "aws_acm_certificate_validation" "dns_name_cert_validation" {
  certificate_arn         = aws_acm_certificate.dns_name_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.dns_name_cert_validation : record.fqdn]
}
