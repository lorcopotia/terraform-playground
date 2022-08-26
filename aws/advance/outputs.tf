output "lb_url" {
  value = "http://${aws_lb.webapp_asg_lb.dns_name}"
  depends_on = [
    aws_lb.webapp_asg_lb
  ]
}
