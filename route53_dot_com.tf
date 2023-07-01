resource "aws_route53_zone" "wagonkered_hosted_zone_dot_com" {
  name = var.domain_name_dot_com
}

resource "aws_route53_record" "certification_validation_dot_com" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.wagonkered_hosted_zone_dot_com.zone_id
}

resource "aws_route53_record" "url_ip4_dot_com" {
  name    = var.domain_name_dot_com
  zone_id = aws_route53_zone.wagonkered_hosted_zone_dot_com.zone_id
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution_redirect.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution_redirect.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "url_ip6_dot_com" {
  name    = var.domain_name_dot_com
  zone_id = aws_route53_zone.wagonkered_hosted_zone_dot_com.zone_id
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution_redirect.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution_redirect.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_ip4_dot_com" {
  name    = "www.${var.domain_name_dot_com}"
  zone_id = aws_route53_zone.wagonkered_hosted_zone_dot_com.zone_id
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution_redirect.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution_redirect.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_ip6_dot_com" {
  name    = "www.${var.domain_name_dot_com}"
  zone_id = aws_route53_zone.wagonkered_hosted_zone_dot_com.zone_id
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution_redirect.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution_redirect.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "dev_ip4_dot_com" {
  name    = "dev.${var.domain_name_dot_com}"
  zone_id = aws_route53_zone.wagonkered_hosted_zone_dot_com.zone_id
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution_redirect.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution_redirect.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "dev_ip6_dot_com" {
  name    = "dev.${var.domain_name_dot_com}"
  zone_id = aws_route53_zone.wagonkered_hosted_zone_dot_com.zone_id
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution_redirect.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution_redirect.hosted_zone_id
    evaluate_target_health = false
  }
}

// TODO: Look at email forwarding between domains
/*
resource "aws_route53_record" "email_record" {
  name    = var.domain_name
  zone_id = aws_route53_zone.wagonkered_hosted_zone.zone_id
  ttl     = "3600"
  type    = "MX"
  records = ["10 ${var.mx_domain_1}", "20 ${var.mx_domain_2}", "50 ${var.mx_domain_3}"]
}

resource "aws_route53_record" "spf_record" {
  name    = var.domain_name
  zone_id = aws_route53_zone.wagonkered_hosted_zone.zone_id
  ttl     = "3600"
  type    = "TXT"
  records = ["v=spf1 include:${var.spf_domain} ~all"]
}

*/

