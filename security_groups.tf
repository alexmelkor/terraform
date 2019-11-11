data "aws_security_group" "default" {
  name = "default"
  vpc_id = module.gitlab_vpc.vpc_id
}

resource "aws_security_group_rule" "all_ipv4_icmp" {
  type = "ingress"
  protocol = "icmp"
  from_port = -1
  to_port = -1
  cidr_blocks = [module.gitlab_vpc.vpc_cidr_block]
  security_group_id = data.aws_security_group.default.id
  description = "Allow All IPV4 ICMP"
}

module "bastion_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "bastion-ssh"
  description = "Allow SSH to the Bastion instance"
  vpc_id      = module.gitlab_vpc.vpc_id

  ingress_cidr_blocks = var.allowed_external_cidr_blocks
  ingress_rules       = ["ssh-tcp"]
}

module "gitlab_ssh_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "gitlab-ssh"
  description = "Allow SSH to the GitLab instance from Bastion"
  vpc_id      = module.gitlab_vpc.vpc_id

  ingress_cidr_blocks = [module.gitlab_vpc.vpc_cidr_block]
  ingress_rules       = ["ssh-tcp"]
}

module "gitlab_http_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "bastion-http"
  description = "Allow HTTP/HTTPS to the Bastion instance from anywhere"
  vpc_id      = module.gitlab_vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]
}

module "postgre_rds_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "postgresql"
  description = "Allow connection to the Gitlab PostgreSQL instance"
  vpc_id      = module.gitlab_vpc.vpc_id

  ingress_cidr_blocks = module.gitlab_vpc.private_subnets_cidr_blocks
  ingress_rules       = ["postgresql-tcp"]
}
