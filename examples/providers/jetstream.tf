module "provider" {
  source = "../terraform-modules/providers/openstack"

  project_name         = "BinderHub"
  nb_nodes             = 1
  instance_volume_size = 20
  public_key_path      = "./key.pub"
  os_external_network  = "public"
  os_flavor_master     = "m1.small"
  os_flavor_node       = "m1.small"
  image_id             = "3e2cfdd5-f726-4535-b035-26f72917aa96"
}

module "binderhub" {
  source = "../terraform-modules/binderhub"

  domain    = "${module.dns.domain}"
  admin_user       = "${module.provider.admin_user}"
  TLS_email        = "email@example.ca"
  mem_alloc_gb     = 1.5
  cpu_alloc        = 1
  private_key_path = "~/.ssh/id_rsa"
}
