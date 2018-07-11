module "dns" {
  source = "../terraform-modules/dns/cloudfare"

  jupyter_domain = "jupyter1.calculquebec.cloud"
  binder_domain  = "binder1.calculquebec.cloud"
  public_ip      = "${module.openstack.public_ip}"
}
