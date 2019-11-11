variable "username" {
  default = "postgres"
}

variable "password" {
  default = "password"
}

variable "vpc_security_group_ids" {
  default = []
  type    = list(string)
}

variable "subnet_ids" {
  default = []
  type = list(string)
}