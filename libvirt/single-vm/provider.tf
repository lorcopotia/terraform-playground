terraform {
 required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
    }
  }
}

# instance the provider
provider "libvirt" {
  uri = "qemu:///system"
}

# If you are connecting to a remote server, use this block instead
#provider "libvirt" {
#  alias = "server2"
#  uri   = "qemu+ssh://root@192.168.100.10/system"
#}
