
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
//
//output "gitlab_external_host" {
//  value = "https://${aws_lb.gitlab.dns_name}"
//}
