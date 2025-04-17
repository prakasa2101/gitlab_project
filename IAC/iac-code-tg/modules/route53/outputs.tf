output "zone_id" {
  value = aws_route53_zone.dns_name.zone_id
}

output "vpn_certificate_arn" {
  value = aws_acm_certificate.vpn_certificate.arn
}