provider "openstack" {}

resource "openstack_compute_secgroup_v2" "secgroup_1" {
  name        = "${var.project_name}-secgroup"
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

locals {
  network_name = "${var.project_name}-network"
}

resource "openstack_networking_subnet_v2" "subnet" {
  count = "${1 - var.is_computecanada}"

  name        = "subnet"
  network_id  = "${openstack_networking_network_v2.network_1.id}"
  ip_version  = 4
  cidr        = "10.0.1.0/24"
  enable_dhcp = true
}


resource "openstack_networking_network_v2" "network_1" {
  count = "${1 - var.is_computecanada}"

  name = "${local.network_name}"
}

data "template_file" "kubeadm_master" {
  template = "${file("${path.module}/../../../cloud-init/kubeadm/master.yaml")}"

  vars {
    admin_user = "${var.admin_user}"
  }
}

data "openstack_networking_network_v2" "ext_network" {
  name = "${var.os_external_network}"
}

resource "openstack_networking_router_v2" "router_1" {
  count = "${1 - var.is_computecanada}"

  name                = "${var.project_name}-router"
  external_network_id = "${data.openstack_networking_network_v2.ext_network.id}"
}

resource "openstack_networking_router_interface_v2" "router_interface_1" {
  count = "${1 - var.is_computecanada}"

  router_id = "${openstack_networking_router_v2.router_1.id}"
  subnet_id = "${openstack_networking_subnet_v2.subnet.id}"
}

data "template_file" "kubeadm_node" {
  template = "${file("${path.module}/../../../cloud-init/kubeadm/node.yaml")}"

  vars {
    master_ip  = "${openstack_compute_instance_v2.master.network.0.fixed_ip_v4}"
    admin_user = "${var.admin_user}"
  }
}

data "template_file" "kubeadm_common" {
  template = "${file("${path.module}/../../../cloud-init/kubeadm/common.yaml")}"

  vars {
  }
}

data "template_cloudinit_config" "node_config" {
  part {
    filename     = "common.yaml"
    merge_type   = "list(append)+dict(recurse_array)+str()"
    content_type = "text/cloud-config"
    content      = "${data.template_file.kubeadm_common.rendered}"
  }

  part {
    filename     = "node.yaml"
    merge_type   = "list(append)+dict(recurse_array)+str()"
    content_type = "text/cloud-config"
    content      = "${data.template_file.kubeadm_node.rendered}"
  }
}

data "template_cloudinit_config" "master_config" {
  part {
    filename     = "common.yaml"
    merge_type   = "list(append)+dict(recurse_array)+str()"
    content_type = "text/cloud-config"
    content      = "${data.template_file.kubeadm_common.rendered}"
  }

  part {
    filename     = "master.yaml"
    merge_type   = "list(append)+dict(recurse_array)+str()"
    content_type = "text/cloud-config"
    content      = "${data.template_file.kubeadm_master.rendered}"
  }
}

resource "openstack_compute_keypair_v2" "keypair" {
  name       = "${var.project_name}-keypair"
  public_key = "${file(var.public_key_path)}"
}

resource "openstack_compute_instance_v2" "master" {
  name            = "master"
  flavor_name     = "${var.os_flavor_master}"
  key_pair        = "${openstack_compute_keypair_v2.keypair.name}"
  security_groups = ["${openstack_compute_secgroup_v2.secgroup_1.name}"]
  user_data       = "${data.template_cloudinit_config.master_config.rendered}"

  block_device {
    uuid                  = "${var.image_id}"
    source_type           = "image"
    volume_size           = "${var.instance_volume_size}"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network = {
    name = "${var.is_computecanada ? var.cc_private_network : local.network_name}"
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
    uuid                  = "${var.image_id}"
    source_type           = "image"
    volume_size           = "${var.instance_volume_size}"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network = {
    name = "${var.is_computecanada ? var.cc_private_network : local.network_name}"
  }
}

resource "openstack_networking_floatingip_v2" "fip_1" {
	pool = "${var.os_external_network}"
}

resource "openstack_compute_floatingip_associate_v2" "fip_1" {
	floating_ip = "${openstack_networking_floatingip_v2.fip_1.address}"
	instance_id = "${openstack_compute_instance_v2.master.id}"
}
