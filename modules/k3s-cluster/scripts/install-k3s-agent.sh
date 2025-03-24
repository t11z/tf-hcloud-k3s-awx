#!/bin/bash

set -eux
sleep 10

# Set required vars (injected by Terraform)
SERVER_IP="${server_ip}"
CLUSTER_TOKEN="${cluster_token}"
CLUSTER_NAME="${cluster_name}"

# Install K3S as agent
curl -sfL https://get.k3s.io | K3S_URL="https://${SERVER_IP}:6443" K3S_TOKEN="${CLUSTER_TOKEN}" sh -
