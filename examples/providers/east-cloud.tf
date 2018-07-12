module "openstack" {
  source = "../terraform-modules/providers/openstack"

  nb_nodes             = 1
  instance_volume_size = 10
  public_key_path      = "./key.pub"
  os_external_network  = "net04_ext"
  os_flavor_master     = "p2-3gb"
  os_flavor_node       = "p2-3gb"
}

module "binderhub" {
  source = "../terraform-modules/binderhub"

  jupyter_domain   = "${module.dns.jupyter_domain}"
  binder_domain    = "${module.dns.binder_domain}"
  admin_user       = "${module.openstack.admin_user}"
  TLS_email        = "my_email@example.ca"
  mem_alloc_gb     = 1.5
  cpu_alloc        = 1
  private_key_path = "~/.ssh/id_rsa"
}
