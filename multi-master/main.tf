terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.43"
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
