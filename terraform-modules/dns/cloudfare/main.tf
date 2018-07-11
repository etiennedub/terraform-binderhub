provider "cloudflare" {}

resource "cloudflare_record" "binder" {
  domain = "${join(".", slice(split(".", var.binder_domain), 1, length(split(".", var.binder_domain))))}"
  name   = "${element(split(".", var.binder_domain), 0)}"
  value  = "${var.public_ip}"
  type   = "A"
  ttl    = 3600
}

resource "cloudflare_record" "jupyter" {
  domain = "${join(".", slice(split(".", var.jupyter_domain), 1, length(split(".", var.jupyter_domain))))}"
  name   = "${element(split(".", var.jupyter_domain), 0)}"
  value  = "${var.public_ip}"
  type   = "A"
  ttl    = 3600
}
