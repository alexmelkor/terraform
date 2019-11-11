// TODO: Protect volume forom destroy/replace
resource "aws_ebs_volume" "gitlab_home" {
  availability_zone = var.availability_zone
  size              = 9 //TODO: Concides to extract size to the variables

  tags = {
    Name = "GitLab home"
  }
}
