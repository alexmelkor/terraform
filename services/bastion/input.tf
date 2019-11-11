variable "ami_name_filter" {
  default = "amzn2-ami-hvm*"
}

variable "ami_owner" {
  default = "amazon"
}

variable "instance_type" {
  default = "t2.micro"
}

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
