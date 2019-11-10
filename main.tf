
module "gitlab_instance" {
  source                  = "./services/gitlab"

  ssh_key_name            = "key-eu-central-1"
  subnet_id               = aws_subnet.private.id
  vpc_security_group_ids  = [data.aws_security_group.default.id]
}
