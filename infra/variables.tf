variable "region" {}

variable "project" {
  default = "rl"
}

variable "env" {}

variable "vpc_cidr" {}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "db_username" {}
variable "db_password" {}
variable "db_name" {}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "hop_url" {}
variable "hop_username" {}
variable "hop_password" {}
variable "aws_region" {

  type = string
}