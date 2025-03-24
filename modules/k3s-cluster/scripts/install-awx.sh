#!/bin/bash

set -eux

# Variables injected via templatefile()
AWX_OPERATOR_VERSION="${awx_operator_version}"

# Use bundled kubectl from K3S
KUBECTL="/usr/local/bin/kubectl"

# Wait until API is ready
until $KUBECTL get nodes &>/dev/null; do
  echo "Waiting for Kubernetes API..."
  sleep 5
done

# Create AWX namespace
$KUBECTL create namespace awx || true

# Deploy AWX Operator from specific tag
$KUBECTL apply -n awx -f https://raw.githubusercontent.com/ansible/awx-operator/${AWX_OPERATOR_VERSION}/deploy/awx-operator.yaml

# Wait for Operator to be running
echo "Waiting for AWX Operator pod..."
until $KUBECTL get pods -n awx | grep awx-operator | grep Running; do
  sleep 5
done

# Create AWX instance
cat <<EOF | $KUBECTL apply -n awx -f -
apiVersion: awx.ansible.com/v1beta1
kind: AWX
metadata:
  name: awx
spec:
  service_type: NodePort
  ingress_type: none
  hostname: ${domain_name}
EOF
