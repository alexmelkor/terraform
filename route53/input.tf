variable "vpc_id" {
  default = ""
}

variable "zone_name" {
  default = "gitlab.gavno"
}

variable "main_records" {
  default = []
  type    = list(string)
}

variable "database_records" {
  default = []
  type    = list(string)
}

variable "database_cname" {
  default = "rds"
}