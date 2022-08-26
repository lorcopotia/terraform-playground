output "data_query" {
  value = data.aws_region.current
}

output "public_ip_webserver" {
  value = module.webserver.public_ip
}

output "public_dns_webserver" {
  value = module.webserver.public_dns
}

output "key_pair_details" {
  value = data.aws_key_pair.mykey
}