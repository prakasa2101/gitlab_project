### Add ACM certificate for VPN

resource "aws_acm_certificate" "vpn_certificate" {
  domain_name       = "vpn.${var.dns_name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "vpn_certificate_validation_records" {
  for_each = {
    for dvo in aws_acm_certificate.vpn_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  #   allow_overwrite = true
  name    = each.value.name
  records = [each.value.record]
  ttl     = 60
  type    = each.value.type
  zone_id = aws_route53_zone.dns_name.zone_id
}

resource "aws_acm_certificate_validation" "vpn_certificate_validation" {
  certificate_arn         = aws_acm_certificate.vpn_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.vpn_certificate_validation_records : record.fqdn]
}
