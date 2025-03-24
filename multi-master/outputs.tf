output "awx_url" {
  value       = module.k3s_cluster.awx_url
  description = "Login URL for AWX"
}

output "awx_password_cmd" {
  value = "ssh root@${module.k3s_cluster.load_balancer_ip} 'cat /root/awx_password.txt'"
  description = "Run this command to retrieve the AWX admin password"
}
