resource "random_password" "password" {
  keepers = {
    datetime = timestamp()
  }
  length  = 16
  special = true
}

resource "random_uuid" "guid" {}

resource "tls_private_key" "tls" {
  algorithm = "RSA"
}

resource "local_file" "tls-public" {
  filename = "id_rsa.pub"
  content  = tls_private_key.tls.public_key_openssh
}

resource "local_file" "tls-private" {
  filename = "id_rsa.pem"
  content  = tls_private_key.tls.private_key_pem
  provisioner "local-exec" {
    command = "chmod 600 id_rsa.pem"
  }
}

output "password" {
  value     = random_password.password.result
  sensitive = true
}

output "guid" {
  value = random_uuid.guid.result
}