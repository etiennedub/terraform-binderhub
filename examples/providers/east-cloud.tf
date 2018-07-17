module "provider" {
  source = "../terraform-modules/providers/openstack"

  project_name         = "BinderHub"
  nb_nodes             = 1
  instance_volume_size = 20
  public_key_path      = "./key.pub"
  os_external_network  = "net04_ext"
  os_flavor_master     = "p2-3gb"
  os_flavor_node       = "p2-3gb"
  image_id             = "080462a8-42b2-4875-9ff6-bf014eb1ee99"
  is_computecanada     = true
  cc_private_network   = "default_network"
}

module "binderhub" {
  source = "../terraform-modules/binderhub"

  jupyter_domain   = "${module.dns.jupyter_domain}"
  binder_domain    = "${module.dns.binder_domain}"
  admin_user       = "${module.provider.admin_user}"
  TLS_email        = "email@example.ca"
  mem_alloc_gb     = 1.5
  cpu_alloc        = 1
  private_key_path = "~/.ssh/id_rsa"
}
