variable "server_count" {
  type        = number
  description = "Number of K3S server nodes"
}

variable "agent_count" {
  type        = number
  description = "Number of K3S agent nodes"
}

variable "cluster_name" {
  type        = string
  description = "Base name for the cluster"
}

variable "server_type" {
  type        = string
  description = "Hetzner Cloud server type"
}

variable "location" {
  type        = string
  description = "Hetzner Cloud location (e.g. fsn1, nbg1)"
}

variable "ssh_keys" {
  type        = list(string)
  description = "List of SSH key names to inject"
}

variable "cluster_token" {
  type        = string
  description = "Shared K3S token for joining cluster"
}

variable "domain_name" {
  type        = string
  description = "Domain name for Load Balancer and TLS cert"
}

variable "awx_nodeport" {
  type        = number
  description = "NodePort on which AWX is exposed"
}

variable "awx_operator_version" {
  type        = string
  description = "Git tag of the AWX Operator to deploy (e.g. '2.19.1')"
}

variable "certificate_name" {
  type        = string
  description = "Name of the pre-uploaded TLS certificate in Hetzner Cloud"
}
