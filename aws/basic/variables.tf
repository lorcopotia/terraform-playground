variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "vpc_name" {
  type    = string
  default = "demo_vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "private_subnets" {
  default = {
    "private_subnet_1" = 1
    "private_subnet_2" = 2
  }
}

variable "public_subnets" {
  default = {
    "public_subnet_1" = 1
    "public_subnet_2" = 2
  }
}

variable "linux_ami" {
  default     = "ami-065deacbcaac64cf2"
  description = "Free tier ami"
}

variable "size" {
  default = "t2.micro"
}

variable "privatekeypath" {
  default = "/home/dunix/.ssh/id_rsa"
}