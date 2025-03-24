output "server_ips" {
  value       = hcloud_server.server.*.ipv4_address
  description = "Public IPv4 addresses of all K3S server nodes"
}

output "awx_url" {
  value       = "https://${var.domain_name}"
  description = "Login URL for AWX"
}
