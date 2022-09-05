variable "hostname" {
  type    = list(string)
  default = ["dev1-centos", "dev2-centos"]
}
variable "domain" { default = "local" }
variable "memoryMB" { default = 1024 * 2 }
variable "cpu" { default = 2 }
