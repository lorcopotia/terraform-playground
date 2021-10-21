terraform {
 required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "os_image" {
  name   = "os_image"
  #source = "https://cloud.centos.org/altarch/7/images/CentOS-7-x86_64-GenericCloud-2009.qcow2"
  source = "/mnt/DATOS/Instalar/ISOS/CentOS-7-x86_64-GenericCloud-2009.qcow2"
}

resource "libvirt_volume" "volume" {
  name           = "volume-${count.index}"
  base_volume_id = libvirt_volume.os_image.id
  count          = length(var.hostname)
}

resource "libvirt_cloudinit_disk" "commoninit" {
          count = length(var.hostname)
          name = "${var.hostname[count.index]}-commoninit.iso"
          user_data = templatefile("${path.module}/cloud_init_centos.cfg",
                                   { hostname = element(var.hostname, count.index), fqdn = "${var.hostname[count.index]}.${var.domain}" })
          network_config = file("${path.module}/network_config.cfg")
}

resource "libvirt_domain" "nodes" {
  name = "${var.hostname[count.index]}"
  memory = var.memoryMB
  vcpu = var.cpu

  disk {
    volume_id = element(libvirt_volume.volume.*.id, count.index)
  }

  network_interface {
    network_name   = "default"
    wait_for_lease = true
  }

  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id

  count = length(var.hostname)
}

output "ips" {
  value = libvirt_domain.nodes.*.network_interface.0.addresses
}
