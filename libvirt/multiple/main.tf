terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "os_image" {
  name = "os_image"
  source = "https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-2111.qcow2"
}

resource "libvirt_volume" "volume" {
  name           = "volume-${count.index}"
  base_volume_id = libvirt_volume.os_image.id
  count          = length(var.hostname)
}

resource "libvirt_cloudinit_disk" "commoninit" {
  count = length(var.hostname)
  name  = "${var.hostname[count.index]}-commoninit.iso"
  user_data = templatefile("${path.module}/cloud_init_centos_k8s_base.cfg",
    { hostname = element(var.hostname, count.index), fqdn = "${var.hostname[count.index]}.${var.domain}" })
}

resource "libvirt_network" "kube_net" {
    name      = "kubernetes"
    mode      = "nat"
    domain    = var.domain
    addresses = var.network
    dhcp {
      enabled = false
    }
    dns {
      enabled = true
    }
}

resource "libvirt_domain" "nodes" {
  name   = var.hostname[count.index]
  memory = var.memoryMB
  vcpu   = var.cpu

  disk {
    volume_id = element(libvirt_volume.volume.*.id, count.index)
  }

  network_interface {
    network_name = "kubernetes"
    network_id     = libvirt_network.kube_net.id
    addresses = ["${var.ipaddr[count.index]}"]
  }

  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id
  qemu_agent = true

  count = length(var.hostname)
}

output "ips" {
  value = libvirt_domain.nodes.*.network_interface.0.addresses
}