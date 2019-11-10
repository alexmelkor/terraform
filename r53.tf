
resource "aws_route53_zone" "gitlab" {
  name = var.gitlab_host_name

  vpc {
    vpc_id  = aws_vpc.gitlab.id
  }
}

resource "aws_route53_record" "gitlab_a" {
  zone_id = aws_route53_zone.gitlab.id
  name    = var.gitlab_host_name
  type    = "A"
  ttl     = 1500
//  records = [aws_instance.gitlab.private_ip]
  records = [module.gitlab_instance.private_ip]
}

resource "aws_route53_record" "gitlab_rds" {
  zone_id = aws_route53_zone.gitlab.id
  name    = "rds"
  type    = "CNAME"
  ttl     = 1500
  records = [aws_db_instance.gitlab_postgres.address]
}
