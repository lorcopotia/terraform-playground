data "template_file" "network_config" {
  template = file("${path.module}/network_config.cfg")
}

# for more info about paramater check this out
# https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/website/docs/r/cloudinit.html.markdown
# Use CloudInit to add our ssh-key to the instance
# you can add also meta_data field
resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit.iso"
  user_data      = templatefile("${path.module}/cloud_init.cfg", { hostname = "${var.hostname}", fqdn = "${var.hostname}.${var.domain}" })
  network_config = data.template_file.network_config.rendered
  pool           = "default"
}
