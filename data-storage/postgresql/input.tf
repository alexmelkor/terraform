variable "name" {
  default = "gitlabhq_production"
}

variable "username" {
  default = "gitlab"
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