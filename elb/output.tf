output "elb_id" {
  value = aws_lb.gitlab.id
}

output "dns_name" {
  value = aws_lb.gitlab.dns_name
}