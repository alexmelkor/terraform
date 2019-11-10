output "gitlab_ami" {
  value = data.aws_ami.gtilab.id
}

output "id" {
  value = aws_instance.gitlab.id
}

output "private_ip" {
  value = aws_instance.gitlab.private_ip
}
