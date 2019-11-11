output "gitlab_ami" {
  value = data.aws_ami.gtilab.id
}

output "gitlab_ami_name" {
  value = data.aws_ami.gtilab.name
}

output "id" {
  value = aws_instance.gitlab.id
}

output "private_ip" {
  value = aws_instance.gitlab.private_ip
}
