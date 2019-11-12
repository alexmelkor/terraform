
module "gitlab_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                  = "GitLab"
  cidr                  = "10.0.0.0/16"

  azs                   = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  public_subnets        = ["10.0.0.0/24"]
  private_subnets       = ["10.0.1.0/24"]
  database_subnets      = ["10.0.10.0/24", "10.0.11.0/24"]

  enable_dns_hostnames  = true
  enable_dns_support    = true

  enable_nat_gateway    = var.enable_nat_gateway
  single_nat_gateway    = true

  public_subnet_tags    = {"Name": "GitLab Public"}
  private_subnet_tags   = {"Name": "GitLab Private"}
  database_subnet_tags  = {"Name": "GitLab RDS"}

  tags = {
    Name = "GitLab"
    Terraform = "true"
  }
}

module "bastion_instance" {
  source = "./services/bastion"

  ami_name_filter = "amzn2-ami-hvm*"
  ssh_key_name    = var.ssh_key_name
  subnet_id       = module.gitlab_vpc.public_subnets[0]

  vpc_security_group_ids  = [
    data.aws_security_group.default.id,
    module.bastion_sg.this_security_group_id
  ]
}

module "gitlab_instance" {
  source = "./services/gitlab"

  ami_name_filter = "amzn-ami-hvm-2018.03.0.20190826-x86_64-gp2"
  ssh_key_name    = var.ssh_key_name
  subnet_id       = module.gitlab_vpc.private_subnets[0]
  attach_ebs      = true
  ebs_id          = "vol-056eb161695591022"

  vpc_security_group_ids  = [
    data.aws_security_group.default.id,
    module.gitlab_ssh_sg.this_security_group_id,
    module.gitlab_http_sg.this_security_group_id
  ]
}

module "gitlab_rds" {
  source = "./data-storage/postgresql"

  subnet_ids  = module.gitlab_vpc.database_subnets

  vpc_security_group_ids = [
    data.aws_security_group.default.id,
    module.postgre_rds_sg.this_security_group_id
  ]
}

module "route53" {
  source = "./route53"

  vpc_id            = module.gitlab_vpc.vpc_id
  main_records      = [module.gitlab_instance.private_ip]
  database_records  = [module.gitlab_rds.address]
}

module "gitlab_elb" {
  source = "./elb"

  name        = "gitlab-gavno"
  vpc_id      = module.gitlab_vpc.vpc_id
  subnets     = module.gitlab_vpc.public_subnets
  instance_id = module.gitlab_instance.id
}
