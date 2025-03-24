#!/bin/bash

set -eux

DOMAIN_NAME="${domain_name}"
BACKEND_PORT="${backend_port}"
BACKEND_HOSTS="${backend_hosts}"

apt update
apt install -y haproxy certbot

# Certbot standalone to get cert
systemctl stop haproxy || true
certbot certonly --standalone --non-interactive --agree-tos -m admin@${DOMAIN_NAME} -d ${DOMAIN_NAME}

# HAProxy config
cat <<EOF > /etc/haproxy/haproxy.cfg
global
    log /dev/log local0
    maxconn 2048
    daemon

defaults
    log     global
    mode    http
    option  httplog
    timeout connect 5s
    timeout client  30s
    timeout server  30s

frontend https_front
    bind *:443 ssl crt /etc/letsencrypt/live/${DOMAIN_NAME}/fullchain.pem key /etc/letsencrypt/live/${DOMAIN_NAME}/privkey.pem
    default_backend awx_nodes

backend awx_nodes
    balance roundrobin
$(for ip in $BACKEND_HOSTS; do echo "    server awx-${ip} ${ip}:${BACKEND_PORT} check"; done)
EOF

systemctl enable haproxy
systemctl restart haproxy
