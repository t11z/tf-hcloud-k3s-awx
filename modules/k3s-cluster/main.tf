terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.43"
    }
    random = {
      source = "hashicorp/random"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

resource "hcloud_server" "server" {
  count       = var.server_count
  name        = "${var.cluster_name}-server-${count.index + 1}"
  image       = "ubuntu-24.04"
  server_type = var.server_type
  location    = var.location
  ssh_keys    = var.ssh_keys
  user_data = templatefile("${path.module}/scripts/install-k3s-server.sh", {
    server_index         = count.index
    cluster_token        = var.cluster_token
    cluster_name         = var.cluster_name
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