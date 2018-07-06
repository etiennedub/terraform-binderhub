provider "cloudflare" {}

resource "cloudflare_record" "binder" {
  domain = "${join(".", slice(split(".", var.binder_domain), 1, length(split(".", var.binder_domain))))}"
  name   = "${element(split(".", var.binder_domain), 0)}"
  value  = "${openstack_networking_floatingip_v2.fip_1.address}"
  type   = "A"
  ttl    = 3600
}

resource "cloudflare_record" "jupyter" {
  domain = "${join(".", slice(split(".", var.jupyter_domain), 1, length(split(".", var.jupyter_domain))))}"
  name   = "${element(split(".", var.jupyter_domain), 0)}"
  value  = "${openstack_networking_floatingip_v2.fip_1.address}"
  type   = "A"
  ttl    = 3600
}
