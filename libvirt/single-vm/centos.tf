# Uncomment if the pool is not created yet
#resource "libvirt_pool" "centos" {
#  name = "centos"
#  type = "dir"
#  path = "/tmp/terraform-provider-libvirt-pool-centos"
#}

# We fetch the latest ubuntu release image from their mirrors
resource "libvirt_volume" "centos-qcow2" {
  name   = "centos-qcow2"
  pool   = "default"
  source = "https://cloud.centos.org/altarch/7/images/CentOS-7-x86_64-GenericCloud-2009.qcow2"
  format = "qcow2"
}

# Create the machine
resource "libvirt_domain" "vm-centos" {
  name   = "centos"
  memory = "512"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_name = "default"
  }

  # IMPORTANT: this is a known bug on cloud images, since they expect a console
  # we need to pass it
  # https://bugs.launchpad.net/cloud-images/+bug/1573095
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.ubuntu-qcow2.id
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
