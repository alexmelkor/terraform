data "aws_ami" "gtilab" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "aws_subnet" "selected" {
  id = var.subnet_id
}

resource "aws_instance" "gitlab" {
  ami                         = data.aws_ami.gtilab.id
  associate_public_ip_address = false
  instance_type               = "t2.micro"
  key_name                    = var.ssh_key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids

  root_block_device {
    volume_size           = 12
    delete_on_termination = true
  }

  tags = {
    Name = "GitLab"
  }
}

// TODO: Investigate automount: Do it with user_data or via option of config manager script?
//resource "aws_volume_attachment" "ebs_att" {
//  instance_id   = aws_instance.gitlab.id
//  device_name   = "/dev/sdh"
//  skip_destroy  = true
//  volume_id     = aws_ebs_volume.gitlab_home.id
//}

// TODO: Protect volume forom destroy/replace
resource "aws_ebs_volume" "gitlab_home" {
  availability_zone = data.aws_subnet.selected.availability_zone
  size              = 9 //TODO: Concides to extract size to the variables

  tags = {
    Name = "GitLab home"
  }
}
