output "bastion_ami" {
  value = data.aws_ami.bastion.id
}

output "bastion_ami_name" {
  value = data.aws_ami.bastion.name
}

output "id" {
  value = aws_instance.bastion.id
}

output "private_ip" {
  value = aws_instance.bastion.private_ip
}

output "public_dns" {
  value = aws_instance.bastion.public_dns
}
