# Uncomment if the pool is not created yet
#resource "libvirt_pool" "centos" {
#  name = "centos"
#  type = "dir"
#  path = "/tmp/terraform-provider-libvirt-pool-centos"
#}

# We fetch the latest centos release image from their mirrors
resource "libvirt_volume" "centos-qcow2" {
  name   = "centos-qcow2"
  pool   = "default"
  source = "https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-2111.qcow2"
  format = "qcow2"
}

# Create the machine
resource "libvirt_domain" "vm-centos" {
  name   = var.hostname
  memory = var.memoryMB
  vcpu   = var.cpu

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_name = "default"
  }

  disk {
    volume_id = libvirt_volume.centos-qcow2.id
  }
  
  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

}

# IPs: use wait_for_lease true or after creation use terraform refresh and terraform show for the ips of domain
output "ips" {
  value = libvirt_domain.vm-centos.network_interface.0.addresses
}
