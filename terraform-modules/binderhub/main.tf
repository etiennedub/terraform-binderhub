resource "random_id" "token" {
  count       = 2
  byte_length = 32
}

# Install on GCP
resource "null_resource" "gcp_install" {
  count = "${var.is_gcp == true ? 1 : 0}"

  provisioner "local-exec" {
    command = <<EOT
      cp ${path.module}/assets/*.template /tmp/;
      bash ${path.module}/assets/install-binderhub.sh
EOT

    environment {
      api_token="${random_id.token.0.hex}"
      secret_token="${random_id.token.1.hex}"
      domain="${var.domain}"
      TLS_email="${var.TLS_email}"
      cpu_alloc="${var.cpu_alloc}"
      mem_alloc="${var.mem_alloc_gb}"
      gcp="true"

      public_ip="${var.public_ip}"
    }
  }

}

# Install on Kubeadm
resource "null_resource" "remote_install" {
  count = "${var.is_gcp == false ? 1 : 0}"

  connection {
    user        = "${var.admin_user}"
    private_key = "${file("${var.private_key_path}")}"
    host        = "${var.domain}"
  }

  provisioner "file" {
    source      = "${path.module}/assets/"
    destination = "/tmp/"
  }

  provisioner "remote-exec" {
    inline = [
      "api_token=${random_id.token.0.hex} secret_token=${random_id.token.1.hex} domain=${var.domain} TLS_email=${var.TLS_email} cpu_alloc=${var.cpu_alloc} mem_alloc=${var.mem_alloc_gb}  admin_user=${var.admin_user} bash /tmp/install-binderhub.sh"
    ]
  }
}
