output "public_ip" {
  value       = hcloud_server.lb.ipv4_address
  description = "Public IP of the Loadbalancer"
}
