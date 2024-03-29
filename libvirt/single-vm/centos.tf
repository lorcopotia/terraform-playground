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
  qemu_agent = true
}

# for more info about paramater check this out
# https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/website/docs/r/cloudinit.html.markdown
# Use CloudInit to add our ssh-key to the instance
# you can add also meta_data field
resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit.iso"
  user_data      = templatefile("${path.module}/cloud_init_centos_ansible.cfg", { hostname = "${var.hostname}", fqdn = "${var.hostname}.${var.domain}" })
  network_config = data.template_file.network_config.rendered
  pool           = "default"
}

data "template_file" "network_config" {
  template = file("${path.module}/network_config.cfg")
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
    type        = "vnc"
    listen_type = "address"
    autoport    = true
  }

}

# IPs: use wait_for_lease true or after creation use terraform refresh and terraform show for the ips of domain
output "ips" {
  value = libvirt_domain.vm-centos.network_interface.0.addresses
}
