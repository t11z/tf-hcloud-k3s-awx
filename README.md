# Hetzner Cloud K3S + AWX Terraform Deployment

This project automates the provisioning of a K3S cluster with AWX installed on top, running inside Hetzner Cloud. It supports both single-master and multi-master configurations, and includes:

- Automated deployment of K3S Server and Agent nodes (Ubuntu 24.04)
- AWX installed via the official AWX Operator
- A dedicated Ubuntu-based HAProxy load balancer with Let's Encrypt TLS
- Fully modular Terraform structure
- Auto-generated outputs including AWX login URL and retrieval command for the admin password

## 📦 Supported Cluster Types

### Single-Master Cluster (`single-master/`)
- 1x K3S server node
- 2x K3S agent nodes
- AWX is deployed on the server node

### Multi-Master Cluster (`multi-master/`)
- 3x K3S server nodes (HA setup)
- No agent nodes
- AWX is deployed on the first server node

## 🚀 Quickstart

```bash
# Clone the repository and choose a setup
cd single-master    # or: cd multi-master

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Deploy the cluster
terraform apply
```

Once completed, Terraform will output:
- The AWX login URL (with valid TLS)
- A command to retrieve the initial admin password from the deployed cluster
- The public IP address of your HAProxy load balancer

## ⚙️ `terraform.tfvars` Reference

Below is a list of all supported input variables and example values:

| Variable Name           | Description                                                          | Example                                  |
|-------------------------|----------------------------------------------------------------------|------------------------------------------|
| `hcloud_token`          | Hetzner Cloud API token (keep secret)                                | `"your-hcloud-api-token"`                |
| `ssh_keys`              | List of SSH key names already uploaded to Hetzner Cloud              | `["my-hetzner-key"]`                     |
| `server_type`           | Type of VM (from Hetzner offerings)                                  | `"cx31"`                                 |
| `location`              | Hetzner datacenter location                                          | `"fsn1"`                                 |
| `cluster_name`          | Base name for the cluster and resources                              | `"awx-single"`                           |
| `domain_name`           | Public domain to be secured by Let's Encrypt                         | `"awx.nakatomi-corp.eu"`                |
| `awx_operator_version`  | AWX Operator release tag (use stable release)                        | `"2.19.1"`                               |
| `awx_nodeport`          | NodePort used to expose AWX service inside the cluster               | `30080`                                  |
| `private_key_path`      | Path to your private SSH key for post-deploy password retrieval      | `"~/.ssh/id_rsa"`                        |


## 📤 Outputs

Terraform provides several key outputs:

- `awx_url`: URL to access AWX (TLS-enabled)
- `awx_password_cmd`: SSH command to retrieve the initial admin password from the deployed cluster
- `loadbalancer_ip`: The public IPv4 address of your HAProxy TLS endpoint

## 🔐 TLS & Load Balancing

This project uses a dedicated Ubuntu 24.04 VM as a **HAProxy-based load balancer**, provisioned and configured via Terraform. It performs:

- Automatic TLS certificate issuance using **Let's Encrypt**
- HTTPS termination at the edge (HAProxy)
- TCP forwarding to K3S server nodes via AWX NodePort
- Load balancing across all server nodes (round-robin)

Your domain (e.g., `awx.nakatomi.corp`) must already point to the public IP of the load balancer.

## ⚠️ DNS Requirement

Before running `terraform apply`, ensure that the domain (`domain_name`) already resolves to the IP address that will be assigned to the HAProxy load balancer.

You can use a wildcard DNS record like `*.nakatomi.corp`, or a specific one like `awx.nakatomi.corp`.

## 📌 Notes

- This project assumes a clean Hetzner account with uploaded SSH keys
- For production, consider managing DNS via Terraform too
- Works well with Git versioning and remote Terraform state if needed

## 📮 Feedback & Contributions

Feel free to open issues or suggest improvements.  
If you'd like to extend this to support Ingress controllers, persistent databases, or autoscaling – this structure is modular and ready.
