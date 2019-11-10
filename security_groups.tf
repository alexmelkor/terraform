// TODO: Concider to improve code reuse

// TODO: Clarify is it ok to use default SG or better to use new one?
data "aws_security_group" "default" {
  name = "default"
  vpc_id = aws_vpc.gitlab.id
}

resource "aws_security_group_rule" "bastion_ssh_ingress" {
  type = "ingress"
  protocol = "tcp"
  from_port = 22
  to_port = 22
  cidr_blocks = var.allowed_external_cidr_blocks
  security_group_id = data.aws_security_group.default.id
  description = "Allow SSH to the Bastion instance"
}

resource "aws_security_group_rule" "gitlab_ssh_ingress" {
  type = "ingress"
  protocol = "tcp"
  from_port = 22
  to_port = 22
  cidr_blocks = ["${aws_instance.bastion.private_ip}/32"] //TODO: Clarify is it ok to limit with bastion private ip or use all public network cird
  security_group_id = data.aws_security_group.default.id
  description = "Allow SSH from Bastion to the Gitlab instance"
}

resource "aws_security_group_rule" "gitlab_http_ingress" {
  type = "ingress"
  protocol = "tcp"
  from_port = 80
  to_port = 80
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = data.aws_security_group.default.id
  description = "Allow SSH from Bastion to the Gitlab instance"
}

resource "aws_security_group_rule" "gitlab_https_ingress" {
  type = "ingress"
  protocol = "tcp"
  from_port = 443
  to_port = 443
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = data.aws_security_group.default.id
  description = "Allow SSH from Bastion to the Gitlab instance"
}

// TODO: Extract this to a separate group and explicitly assign to the RDS DB Subnets
resource "aws_security_group_rule" "gitlab_to_postgres_tcp_ingress" {
  type = "ingress"
  protocol = "tcp"
  from_port = 5432
  to_port = 5432
//  cidr_blocks = ["${aws_instance.gitlab.private_ip}/32"]
  cidr_blocks = ["${module.gitlab_instance.private_ip}/32"]
  security_group_id = data.aws_security_group.default.id
  description = "Allow TCP from GitLab to the PostgreSQL RDS instance"
}

//TODO: It's for debug purposes, maybe it should be removed
resource "aws_security_group_rule" "all_ipv4_icmp" {
  type = "ingress"
  protocol = "icmp"
  from_port = -1
  to_port = -1
  cidr_blocks = [aws_vpc.gitlab.cidr_block]
  security_group_id = data.aws_security_group.default.id
  description = "Allow All IPV4 ICMP"
}
