variable "name" {
  default = ""
}

variable "subnets" {
  default = []
  type = list(string)
}

variable "vpc_id" {
  default = ""
}

variable "instance_id" {
  default = ""
}