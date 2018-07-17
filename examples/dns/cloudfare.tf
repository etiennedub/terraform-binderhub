module "dns" {
  source = "../terraform-modules/dns/cloudflare"

  domain    = "mydomainname.com"
  public_ip = "${module.openstack.public_ip}"
}
