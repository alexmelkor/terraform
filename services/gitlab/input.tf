variable "ssh_key_name" {
  default = ""
}

variable "subnet_id" {
  default = ""
}

variable "vpc_security_group_ids" {
  default = []
  type = list(string)
}