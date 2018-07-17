provider "cloudflare" {}

resource "cloudflare_record" "domain" {
  domain = "${join(".", slice(split(".", var.domain), 1, length(split(".", var.domain))))}"
  name   = "${element(split(".", var.domain), 0)}"
  value  = "${var.public_ip}"
  type   = "A"
  ttl    = 3600
}
