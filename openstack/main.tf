variable "nb_nodes" {
  default = 0
}

variable "shared_storage_size" {
  default = 10
}

variable "public_key_path" {
  default = "./key.pub"
}

variable "os_external_network" {
  default = "net04_ext"
}

variable "os_flavor_node" {
  default = "p2-3gb"
}

variable "os_flavor_master" {
  default = "p2-3gb"
}

variable "jupyter_domain" {
  default = "jupyter.calculquebec.cloud"
}

variable "binder_domain" {
  default = "binder.calculquebec.cloud"
}

variable "admin_user" {
  default = "ubuntu"
}

variable "TSL_email" {
  default = "example@calculquebec.ca"
}
