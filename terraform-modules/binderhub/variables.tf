variable "domain" {
  description = "Domain name"
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
  description = "User with root access"
  default     = ""
}

variable "private_key_path" {
  description = "Path to private key file"
  default     = ""
}

variable "is_gcp" {
  description = "Set to true to install BinderHub on Google Cloud"
  default     = false
}

variable "public_ip" {
  description = "PublicIP is not required except for GCP"
  default     = ""
}
