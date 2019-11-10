data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

output "bastion_ami" {
  value = data.aws_ami.amazon-linux-2.id
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon-linux-2.id
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = var.ssh_key_name
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [
    data.aws_security_group.default.id]

  tags = {
    Name = "Basion"
  }
}
