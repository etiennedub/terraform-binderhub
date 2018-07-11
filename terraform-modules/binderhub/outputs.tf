output "binderhub_template" {
  value = "${data.template_file.binderhub.rendered}"
}

