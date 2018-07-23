module "dns" {
  source = "../terraform-modules/dns/jetstream"

  public_ip = "${module.provider.public_ip}"
}

output "url" {
  value = "${module.dns.domain}"
}
