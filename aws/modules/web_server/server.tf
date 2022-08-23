variable "ami" {}
variable "size" {}
variable "subnet_id" {}
variable "user" {}
variable "security_groups" {
  type = list(any)
}
variable "key_name" {}

data "template_file" "user_data" {
  template = file("cloudinit.yaml")
}

resource "aws_instance" "web" {
  ami                    = var.ami
  instance_type          = var.size
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_groups

  associate_public_ip_address = true
  user_data                   = data.template_file.user_data.rendered
  key_name                    = var.key_name

  tags = {
    "Name"        = "Web Server from Module"
    "Environment" = "Training"
  }
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

output "public_dns" {
  value = aws_instance.web.public_dns
}