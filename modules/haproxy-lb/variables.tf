variable "cluster_name" {
  type        = string
  description = "Prefix for naming the Loadbalancer VM"
}

variable "domain_name" {
  type        = string
  description = "The domain name that should be used for TLS"
}

variable "backend_ips" {
  type        = list(string)
  description = "IP addresses of backend K3S server nodes"
}

variable "backend_port" {
  type        = number
  description = "NodePort used by the AWX service"
}

variable "server_type" {
  type        = string
  default     = "cx11"
}

variable "location" {
  type        = string
  default     = "fsn1"
}

variable "ssh_keys" {
  type        = list(string)
  description = "SSH key names to provision the VM"
}
