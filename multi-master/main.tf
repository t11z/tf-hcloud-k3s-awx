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


provider "hcloud" {
  token = var.hcloud_token
}

resource "random_password" "k3s_token" {
  length  = 32
  special = false
}

module "k3s_cluster" {
  source         = "../modules/k3s-cluster"
  server_count   = 3
  agent_count    = 0
  cluster_name   = var.cluster_name
  server_type    = var.server_type
  location       = var.location
  ssh_keys       = var.ssh_keys
  cluster_token  = random_password.k3s_token.result
  domain_name    = var.domain_name
  awx_nodeport   = var.awx_nodeport
  certificate_name     = var.certificate_name
  awx_operator_version = var.awx_operator_version
}

module "haproxy_lb" {
  source         = "../modules/haproxy-lb"
  cluster_name   = var.cluster_name
  domain_name    = var.domain_name
  backend_ips    = module.k3s_cluster.server_ips
  backend_port   = var.awx_nodeport
  server_type    = "cx11"
  location       = var.location
  ssh_keys       = var.ssh_keys
}

resource "null_resource" "get_awx_password" {
  depends_on = [module.k3s_cluster]

  connection {
    type        = "ssh"
    user        = "root"
    host        = module.k3s_cluster.load_balancer_ip
    private_key = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "kubectl get secret awx-admin-password -n awx -o jsonpath='{.data.password}' | base64 -d > /root/awx_password.txt"
    ]
  }
}
