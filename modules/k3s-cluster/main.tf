resource "hcloud_server" "server" {
  count       = var.server_count
  name        = "${var.cluster_name}-server-${count.index + 1}"
  image       = "ubuntu-24.04"
  server_type = var.server_type
  location    = var.location
  ssh_keys    = var.ssh_keys
  user_data   = templatefile("${path.module}/scripts/install-k3s-server.sh", {
    server_index         = count.index
    cluster_token        = var.cluster_token
    cluster_name         = var.cluster_name
    agent_ips            = join(",", hcloud_server.agent.*.ipv4_address)
    awx_install          = count.index == 0 ? true : false
    awx_operator_version = var.awx_operator_version
    domain_name          = var.domain_name
  })
}

resource "hcloud_server" "agent" {
  count       = var.agent_count
  name        = "${var.cluster_name}-agent-${count.index + 1}"
  image       = "ubuntu-24.04"
  server_type = var.server_type
  location    = var.location
  ssh_keys    = var.ssh_keys
  user_data   = templatefile("${path.module}/scripts/install-k3s-agent.sh", {
    server_ip      = hcloud_server.server[0].ipv4_address
    cluster_token  = var.cluster_token
    cluster_name   = var.cluster_name
  })
}

resource "hcloud_load_balancer" "awx_lb" {
  name     = "${var.cluster_name}-lb"
  location = var.location
  load_balancer_type     = "lb11"
}

resource "hcloud_load_balancer_service" "https" {
  load_balancer_id = hcloud_load_balancer.awx_lb.id
  protocol         = "https"
  listen_port      = 443
  destination_port = var.awx_nodeport

  http {
    sticky_sessions = false
    certificates    = [data.hcloud_uploaded_certificate.awx_cert.id]
  }
}

resource "hcloud_load_balancer_target" "servers" {
  count            = var.server_count
  type             = "server"
  server_id        = hcloud_server.server[count.index].id
  load_balancer_id = hcloud_load_balancer.awx_lb.id
  use_private_ip   = false
}

data "hcloud_uploaded_certificate" "awx_cert" {
  name = var.certificate_name
}