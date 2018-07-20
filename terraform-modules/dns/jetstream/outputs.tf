locals {
  search  =  "/\\d+\\.\\d+\\.(\\d+)\\.(\\d+)/" 
  replace =  "js-$1-$2.jetstream-cloud.org"
}

output domain {
  value = "${replace(var.public_ip, local.search, local.replace)}"
}
