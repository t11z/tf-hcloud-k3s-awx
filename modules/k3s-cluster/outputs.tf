output "load_balancer_ip" {
  value       = hcloud_load_balancer.awx_lb.ipv4
  description = "Public IP of the Load Balancer"
}

output "awx_url" {
  value       = "https://${var.domain_name}"
  description = "Login URL for AWX"
}
