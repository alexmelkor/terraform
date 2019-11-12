provider "aws" {
  region = var.region
}

resource "aws_ebs_volume" "gitlab_home" {
  availability_zone     = var.availability_zone
  delete_on_termination = false
  size                  = var.size

  tags = {
    Name = var.tag_name
  }
}
