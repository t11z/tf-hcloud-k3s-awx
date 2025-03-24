#!/bin/bash

set -eux
sleep 10

# Set required vars (injected by Terraform)
SERVER_INDEX=${server_index}
CLUSTER_TOKEN="${cluster_token}"
CLUSTER_NAME="${cluster_name}"
AGENT_IPS="${agent_ips}"
INSTALL_AWX=${awx_install}

# Write the token to disk
echo "${CLUSTER_TOKEN}" > /var/lib/rancher/k3s/server/token

# Only the first server should initialize the cluster
if [ "$SERVER_INDEX" -eq 0 ]; then
  curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--write-kubeconfig-mode 644 --tls-san ${HOSTNAME}" sh -s - server \
    --token "${CLUSTER_TOKEN}"

  # Wait until cluster is ready
  until kubectl get nodes &>/dev/null; do
    echo "Waiting for Kubernetes API..."
    sleep 5
  done

  # Optional: install AWX
  if [ "$INSTALL_AWX" = true ]; then
    bash /root/install-awx.sh
  fi

else
  curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--server https://${AGENT_IPS}:6443" sh -s - server \
    --token "${CLUSTER_TOKEN}"
fi
