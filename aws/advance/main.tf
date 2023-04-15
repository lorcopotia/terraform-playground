# Configure the AWS Provider
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = "dev_asg"
      Terraform   = "true"
    }
  }
}

#Retrieve the key from AWS
data "aws_key_pair" "mykey" {
  key_name           = "dunix-manjaro"
  include_public_key = true
}

#Setting config/template for the ASG instances
resource "aws_launch_configuration" "webapp_asg" {
  name_prefix     = "aws-asg-"
  image_id        = var.linux_ami
  instance_type   = var.size
  key_name        = data.aws_key_pair.mykey.key_name
  user_data       = file("${path.module}/cloudinit.cfg")
  security_groups = [aws_security_group.asg_web.id, aws_security_group.ingress_ssh.id]

  lifecycle {
    create_before_destroy = true
  }
}

#Setting the ASG and telling AWS the config/template I'm gonna use for those instances
resource "aws_autoscaling_group" "webapp_asg" {
  name                 = "webapp-asg"
  min_size             = 1
  max_size             = 3
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.webapp_asg.name
  vpc_zone_identifier  = module.vpc.public_subnets

  tag {
    key                 = "Name"
    value               = "HashiCorp Learn ASG - webapp_asg"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
}

#Creating ALB
resource "aws_lb" "webapp_asg_lb" {
  name               = "webapp-asg-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.asg_web_lb.id]
  subnets            = module.vpc.public_subnets
}

#Creating listener for the ALB
resource "aws_lb_listener" "webapp_asg_lb_listener" {
  load_balancer_arn = aws_lb.webapp_asg_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp_asg_tg.arn
  }
}

#Creating target group for the listener to send traffic
resource "aws_lb_target_group" "webapp_asg_tg" {
  name     = "webapp-asg-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

#Puting all together
resource "aws_autoscaling_attachment" "webapp_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.id
  lb_target_group_arn    = aws_lb_target_group.webapp_asg_tg.arn
}