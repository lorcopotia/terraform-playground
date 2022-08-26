#Getting the availability zone list
data "aws_availability_zones" "available" {
  state = "available"
}

#Deploying the VPC via module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = var.vpc_name
  cidr = "10.0.0.0/16"

  azs                  = data.aws_availability_zones.available.names
  public_subnets       = tolist(var.public_subnets)
  enable_dns_hostnames = true
  enable_dns_support   = true
}

#Deploy the security group for the ASG <- ALB
resource "aws_security_group" "asg_web" {
  name        = "asg-allow-web"
  description = "Allow Web traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow Port 80"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.asg_web_lb.id]
  }

  ingress {
    description     = "TLS from VPC"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.asg_web_lb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "asg_allow_web"
  }
}

resource "aws_security_group" "asg_web_lb" {
  name = "asg-web-lb"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group" "ingress_ssh" {
  name   = "allow-all-ssh"
  vpc_id = module.vpc.vpc_id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}