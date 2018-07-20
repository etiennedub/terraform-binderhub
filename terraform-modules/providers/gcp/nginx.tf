/* provider "kubernetes" { */
/*   host     = "${google_container_cluster.cluster-binderhub.endpoint}" */
/*   username = "${random_string.authentification.0.result}" */
/*   password = "${random_string.authentification.1.result}" */

/*   client_certificate     = "${base64decode(google_container_cluster.cluster-binderhub.master_auth.0.client_certificate)}" */
/*   client_key             = "${base64decode(google_container_cluster.cluster-binderhub.master_auth.0.client_key)}" */
/*   cluster_ca_certificate = "${base64decode(google_container_cluster.cluster-binderhub.master_auth.0.cluster_ca_certificate)}" */
/* } */

/* resource "google_compute_address" "default" { */
/*   depends_on = ["google_container_node_pool.production", "google_container_cluster.cluster-binderhub"] */

/*   name   = "binderhub-ip" */
/*   region = "${var.zone}" */
/* } */

/* resource "kubernetes_namespace" "support" { */
/*   metadata { */
/*     name = "support" */
/*   } */
/* } */

/* resource "kubernetes_service" "nginx" { */
/*   metadata { */
/*     namespace = "${kubernetes_namespace.support.metadata.0.name}" */
/*     name      = "nginx" */
/*   } */

/*   spec { */
/*     selector { */
/*       run = "nginx" */
/*     } */

/*     session_affinity = "ClientIP" */

/*     port { */
/*       protocol    = "TCP" */
/*       port        = 80 */
/*       target_port = 80 */
/*     } */

/*     type             = "LoadBalancer" */
/*     load_balancer_ip = "${google_compute_address.default.address}" */
/*   } */
/* } */

/* resource "kubernetes_replication_controller" "nginx" { */
/*   metadata { */
/*     name      = "nginx" */
/*     namespace = "${kubernetes_namespace.support.metadata.0.name}" */

/*     labels { */
/*       run = "nginx" */
/*     } */
/*   } */

/*   spec { */
/*     selector { */
/*       run = "nginx" */
/*     } */

/*     template { */
/*       container { */
/*         image = "nginx:latest" */
/*         name  = "nginx" */
/*       } */
/*     } */
/*   } */
/* } */
