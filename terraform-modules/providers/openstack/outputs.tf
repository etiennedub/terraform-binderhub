output "public_ip" {
	value = "${openstack_networking_floatingip_v2.fip_1.address}"
}

output "admin_user" {
	value = "${var.admin_user}"
}
