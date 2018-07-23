module "provider" {
  source = "../terraform-modules/providers/gcp"

  project_name          = "project_gcp"
  zone                  = "us-central1"
  zone_region           = "us-central1-a"
  cluster_name          = "${var.username}"
  min_nodes_autoscaling = 1
  max_nodes_autoscaling = 1
  node_type             = "n1-standard-1"
  master_type           = "n1-standard-2"
}

module "binderhub" {
  source = "../terraform-modules/binderhub"

  domain           = "${module.dns.binder_domain}"
  admin_user       = "${module.provider.admin_user}"
  TLS_email        = "email@example.ca"
  mem_alloc_gb     = 1.5
  cpu_alloc        = 1
  private_key_path = "~/.ssh/id_rsa"
  public_ip        = "${module.provider.public_ip}"

  is_gcp = "true"
}

variable "username" {
  description = "Username"
  type        = "string"
}
