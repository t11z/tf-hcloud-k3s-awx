resource "hcloud_server" "lb" {
  name        = "${var.cluster_name}-lb"
  image       = "ubuntu-24.04"
  server_type = var.server_type
  location    = var.location
  ssh_keys    = var.ssh_keys

  user_data = templatefile("${path.module}/scripts/install-haproxy-certbot.sh", {
    domain_name   = var.domain_name
    backend_port  = var.backend_port
    backend_hosts = join(" ", var.backend_ips)
  })
}
