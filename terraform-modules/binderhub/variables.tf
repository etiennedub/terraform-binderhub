variable "jupyter_domain" {
  description = "JupyterHub domain name"
}

variable "binder_domain" {
  description = "BinderHub domain name"
}

variable "TLS_email" {
  description = "Email address used to register TLS certificate"
}

variable "mem_alloc_gb" {
  description = "RAM allocation per user"
}

variable "cpu_alloc" {
  description = "CPU allocation per user (floating point values are supported)"
}

variable "admin_user" {
  default = "ubuntu"
}
