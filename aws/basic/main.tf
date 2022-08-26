# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

#Retrieve the list of AZs in the current AWS region
data "aws_availability_zones" "available" {}
data "aws_region" "current" {}

#Retrieve the key from AWS
data "aws_key_pair" "mykey" {
  key_name           = "dunix-manjaro"
  include_public_key = true
}

module "webserver" {
  source          = "./modules/web_server"
  ami             = var.linux_ami
  size            = var.size
  key_name        = "dunix-manjaro"
  user            = "ubuntu"
  subnet_id       = aws_subnet.public_subnets["public_subnet_1"].id
  security_groups = [aws_security_group.webservers.id, aws_security_group.ingress-ssh.id]
}