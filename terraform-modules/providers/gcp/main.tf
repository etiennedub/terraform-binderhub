
resource "random_string" "authentification" {
  count = 2

  length  = 16
  special = false
}

provider "google" {
  project     = "${var.project_name}"
  region      = "${var.zone}"
}

resource "google_container_cluster" "cluster-binderhub" {
  name                     = "${var.cluster_name}-cluster"
  zone                     = "${var.zone_region}"
  remove_default_node_pool = true

  node_pool {
    name = "default-pool"
  }

  master_auth {
    username = "${random_string.authentification.0.result}"
    password = "${random_string.authentification.1.result}"
  }
}

resource "google_container_node_pool" "production" {
  name       = "${var.cluster_name}-production"
  cluster    = "${google_container_cluster.cluster-binderhub.name}"
  zone       = "${var.zone_region}"
  node_count = "1"

  node_config {
    machine_type = "${var.master_type}"
    image_type   = "ubuntu"
    labels {
      type = "production"
    }
  }

  autoscaling {
    min_node_count = "${var.min_nodes_autoscaling}"
    max_node_count = "${var.max_nodes_autoscaling}"
  }
}

resource "google_container_node_pool" "worker" {
  name       = "${var.cluster_name}-worker"
  cluster    = "${google_container_cluster.cluster-binderhub.name}"
  zone       = "${var.zone_region}"
  node_count = "1"

  node_config {
    machine_type = "${var.node_type}"
    image_type   = "ubuntu"
  }
}

resource "google_compute_address" "default" {
  depends_on = ["google_container_node_pool.production", "google_container_cluster.cluster-binderhub"]

  name   = "${var.cluster_name}-binderhub-ip"
  region = "${var.zone}"
}

resource "null_resource" "remote_install" {
  depends_on = ["google_container_node_pool.production", "google_container_cluster.cluster-binderhub"]

  provisioner "local-exec" {
    command = "sh ${path.module}/assets/setup.sh"

    environment {
      cluster = "${var.cluster_name}"
      zone    = "${var.zone_region}"
      project = "${var.project_name}"
      ip      = "${google_compute_address.default.address}"
    }
  }
}

# TODO: Firewall
