
output "ssh_key_name" {
  value = var.ssh_key_name
}

output "bastion_public_dns" {
  value = module.bastion_instance.public_dns
}

output "gitlab_ptivate_ip" {
  value = module.gitlab_instance.private_ip
}

output "gitlab_db_host" {
  value = "rds.${var.gitlab_host_name}"
}

output "gitlab_dbs_name" {
  value = module.gitlab_elb.dns_name
}
