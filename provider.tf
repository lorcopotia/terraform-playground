# Configure the VMware vSphere Provider
provider "vsphere" {
  user           = var.vsphere-user
  password       = var.vsphere-passwd
  vsphere_server = var.vsphere-server

  # if you have a self-signed cert
  allow_unverified_ssl = true
}
