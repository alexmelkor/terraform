data "aws_ami" "gtilab" {
  most_recent = true
  owners      = [var.ami_owner]

  filter {
    name   = "name"
    values = [var.ami_name_filter]
  }
}

data "aws_subnet" "selected" {
  id = var.subnet_id
}

resource "aws_instance" "gitlab" {
  ami                         = data.aws_ami.gtilab.id
  associate_public_ip_address = false
  instance_type               = var.instance_type
  key_name                    = var.ssh_key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids

  user_data = file("./services/gitlab/user_data/init.sh")

  root_block_device {
    volume_size           = 15
    delete_on_termination = true
  }

  tags = {
    Name = "GitLab"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  count = var.attach_ebs ? 1 : 0

  instance_id   = aws_instance.gitlab.id
  device_name   = "/dev/sdh"
  skip_destroy  = true
  volume_id     = var.ebs_id
}
