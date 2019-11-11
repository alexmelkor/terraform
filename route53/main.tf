
resource "aws_route53_zone" "gitlab" {
  name = var.zone_name

  vpc {
    vpc_id  = var.vpc_id
  }
}

resource "aws_route53_record" "gitlab_a" {
  zone_id = aws_route53_zone.gitlab.id
  name    = var.zone_name
  type    = "A"
  ttl     = 1500
  records = var.main_records
}

resource "aws_route53_record" "gitlab_rds" {
  zone_id = aws_route53_zone.gitlab.id
  name    = var.database_cname
  type    = "CNAME"
  ttl     = 1500
  records = var.database_records
}
