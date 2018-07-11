provider "openstack" {}

data "openstack_networking_subnet_v2" "subnet_1" {}

resource "random_id" "token" {
  count       = 2
  byte_length = 32
}

resource "openstack_compute_secgroup_v2" "secgroup_1" {
  name        = "secgroup"
  description = "BinderHub security group"

  rule {
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
    self        = true
  }

  rule {
    from_port   = 1
    to_port     = 65535
    ip_protocol = "tcp"
    self        = true
  }

  rule {
    from_port   = 1
    to_port     = 65535
    ip_protocol = "udp"
    self        = true
  }

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 443
    to_port     = 443
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

data "template_file" "ubuntu_master" {
  template = "${file("${path.module}/../cloud-init/master.yaml")}"

  vars {
    cidr           = "${data.openstack_networking_subnet_v2.subnet_1.cidr}"
    api_token      = "${random_id.token.0.hex}"
    secret_token   = "${random_id.token.1.hex}"
    jupyter_domain = "${var.jupyter_domain}"
    binder_domain  = "${var.jupyter_domain}"
    admin_user     = "${var.admin_user}"
    TSL_email      = "${var.TSL_email}"
    cpu_alloc      = "${var.cpu_alloc}"
    mem_alloc      = "${var.mem_alloc_gb}"
  }
}

data "template_file" "ubuntu_node" {
  template = "${file("${path.module}/../cloud-init/node.yaml")}"

  vars {
    master_ip  = "${openstack_compute_instance_v2.master.network.0.fixed_ip_v4}"
    admin_user = "${var.admin_user}"
  }
}

data "template_file" "ubuntu_common" {
  template = "${file("${path.module}/../cloud-init/common.yaml")}"

  vars {
  }
}

data "template_cloudinit_config" "node_config" {
  part {
    filename     = "common.yaml"
    merge_type   = "list(append)+dict(recurse_array)+str()"
    content_type = "text/cloud-config"
    content      = "${data.template_file.ubuntu_common.rendered}"
  }

  part {
    filename     = "node.yaml"
    merge_type   = "list(append)+dict(recurse_array)+str()"
    content_type = "text/cloud-config"
    content      = "${data.template_file.ubuntu_node.rendered}"
  }
}

data "template_cloudinit_config" "master_config" {
  part {
    filename     = "common.yaml"
    merge_type   = "list(append)+dict(recurse_array)+str()"
    content_type = "text/cloud-config"
    content      = "${data.template_file.ubuntu_common.rendered}"
  }

  part {
    filename     = "master.yaml"
    merge_type   = "list(append)+dict(recurse_array)+str()"
    content_type = "text/cloud-config"
    content      = "${data.template_file.ubuntu_master.rendered}"
  }
}

resource "openstack_compute_keypair_v2" "keypair" {
  name       = "keypair"
  public_key = "${file(var.public_key_path)}"
}

data "openstack_images_image_v2" "ubuntu" {
  name = "Ubuntu-16.04.2-Xenial-x64-2017-07"
  most_recent = true

  properties {
    key = "value"
  }
}

resource "openstack_compute_instance_v2" "master" {
  name            = "master"
  flavor_name     = "${var.os_flavor_master}"
  key_pair        = "${openstack_compute_keypair_v2.keypair.name}"
  security_groups = ["${openstack_compute_secgroup_v2.secgroup_1.name}"]
  user_data       = "${data.template_cloudinit_config.master_config.rendered}"

  block_device {
    uuid                  = "${data.openstack_images_image_v2.ubuntu.id}"
    source_type           = "image"
    volume_size           = "${var.instance_volume_size}"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }
}

resource "openstack_compute_instance_v2" "node" {
  count    = "${var.nb_nodes}"
  name     = "node${count.index + 1}"

  flavor_name     = "${var.os_flavor_node}"
  key_pair        = "${openstack_compute_keypair_v2.keypair.name}"
  security_groups = ["${openstack_compute_secgroup_v2.secgroup_1.name}"]
  user_data       = "${element(data.template_cloudinit_config.node_config.*.rendered, count.index)}"

  block_device {
    uuid                  = "${data.openstack_images_image_v2.ubuntu.id}"
    source_type           = "image"
    volume_size           = "${var.instance_volume_size}"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }
}

resource "openstack_networking_floatingip_v2" "fip_1" {
	pool = "${var.os_external_network}"
}

resource "openstack_compute_floatingip_associate_v2" "fip_1" {
	floating_ip = "${openstack_networking_floatingip_v2.fip_1.address}"
	instance_id = "${openstack_compute_instance_v2.master.id}"
}
