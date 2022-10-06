variable "hostname" {
  type    = list(string)
  default = ["node1-centos", "node2-centos"]
}
variable "domain" { default = "mylab" }
variable "memoryMB" { default = 1024 * 2 }
variable "cpu" { default = 2 }
variable "network" { default = ["192.168.122.0/24"] }
variable "ipaddr" {
  type    = list(string)
  default = ["192.168.122.180", "192.168.122.181"]
}