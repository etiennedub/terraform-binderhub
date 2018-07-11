variable "nb_nodes" {
  description = "Number of nodes"
}

variable "instance_volume_size" {
  description = "Volume size for each instance"
}

variable "public_key_path" {
  description = "Path to public key file"
}

variable "os_external_network" {
  description = "OpenStack external network name"
}

variable "os_flavor_node" {
  description = "Node flavor"
}

variable "os_flavor_master" {
  description = "Master flavor"
}

variable "binderhub_template" {
  description = "BinderHub cloud-init file content (binderhub module output)"
}

