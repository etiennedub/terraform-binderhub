output "public_ip" {
	value = "${google_compute_address.default.address}"
}

output "admin_user" {
	value = ""
}
