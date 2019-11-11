variable "region" {
  default = "eu-central-1"
}

variable "ssh_key_name" {
  description = "Name of AWS Key paire to provision to the Bastion and Gitlab instances"
  default     = "key-eu-central-1"
}

variable "allowed_external_cidr_blocks" {
  description = ""
  default = ["31.223.230.76/32", "109.68.43.206/32"]
  type    =  list(string)
}

variable "gitlab_host_name" {
  description = "GitLab host name in private Route53 zone"
  default     = "gitlab.gavno"
}

variable "gitlab_db_master_pass" {
  default = "supersicret"
}

variable "enable_nat_gateway" {
  default = true
}
