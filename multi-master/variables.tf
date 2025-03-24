variable "hcloud_token" {
  type        = string
  description = "Hetzner Cloud API Token"
  sensitive   = true
}

variable "ssh_keys" {
  type        = list(string)
  description = "List of SSH key names (already uploaded to Hetzner)"
}

variable "server_type" {
  type        = string
  default     = "cx11"
  description = "Hetzner Cloud server type"
}

variable "location" {
  type        = string
  default     = "fsn1"
  description = "Hetzner Cloud location"
}

variable "cluster_name" {
  type        = string
  default     = "awx-ha"
  description = "Name prefix for cluster resources"
}

variable "domain_name" {
  type        = string
  description = "Domain for TLS cert and AWX URL"
}

variable "awx_nodeport" {
  type        = number
  default     = 30080
  description = "NodePort exposed by the AWX Service"
}

variable "private_key_path" {
  type        = string
  description = "Path to private SSH key for remote exec"
}

variable "certificate_name" {
  type        = string
  description = "Name of the manually uploaded certificate in Hetzner Cloud"
}

variable "awx_operator_version" {
  type        = string
  description = "AWX Operator version to deploy (e.g. '2.19.1')"
}
