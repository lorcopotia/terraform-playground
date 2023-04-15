variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "vpc_name" {
  type    = string
  default = "main-vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
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