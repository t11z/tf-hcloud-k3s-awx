# Hetzner Cloud K3S + AWX Terraform Deployment

This project automates the provisioning of a K3S cluster with AWX installed on top, running inside Hetzner Cloud. It supports both single-master and multi-master configurations, and includes:

- Automated deployment of K3S Server and Agent nodes (Ubuntu 24.04)
- AWX installed via the official AWX Operator
- TLS-Offloading Load Balancer using your own uploaded wildcard certificate
- NodePort access to AWX behind the Load Balancer
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
- The AWX login URL
- A command to retrieve the initial admin password from the deployed instance

## ⚙️ `terraform.tfvars` Reference

Below is a list of all supported input variables and example values:

| Variable Name           | Description                                                          | Example                                  |
|-------------------------|----------------------------------------------------------------------|------------------------------------------|
| `hcloud_token`          | Hetzner Cloud API token (keep secret)                                | `"your-hcloud-api-token"`                |
| `ssh_keys`              | List of SSH key names already uploaded to Hetzner Cloud              | `["my-hetzner-key"]`                     |
| `server_type`           | Type of VM (from Hetzner offerings)                                  | `"cx31"`                                 |
| `location`              | Hetzner datacenter location                                          | `"fsn1"`                                 |
| `cluster_name`          | Base name for the cluster and resources                              | `"awx-single"`                           |
| `domain_name`           | Domain name used for TLS and AWX access                              | `"awx.nakatomi.corp"`                |
| `certificate_name`      | Name of a pre-uploaded wildcard certificate in Hetzner Console       | `"wildcard-nakatomi-corp-eu"`           |
| `awx_operator_version`  | AWX Operator release tag (use stable release)                        | `"2.19.1"`                               |
| `awx_nodeport`          | NodePort used to expose AWX service inside the cluster               | `30080`                                  |
| `private_key_path`      | Path to your private SSH key for post-deploy password retrieval      | `"~/.ssh/id_rsa"`                        |

## 📤 Outputs

Terraform provides two key outputs:

- `awx_url`: URL to access AWX (TLS-enabled)
- `awx_password_cmd`: SSH command to retrieve the initial admin password from the deployed cluster

## 🔐 TLS Certificate Setup

Terraform **does not** manage TLS certificates directly.  
To use TLS offloading, upload a valid certificate manually in the [Hetzner Cloud Console](https://console.hetzner.cloud/) under **Load Balancers → Certificates**, and pass its name using `certificate_name`.

Wildcard certificates are supported (e.g. `*.nakatomi.corp`).

## 📌 Notes

- This project assumes a clean Hetzner account with uploaded SSH keys
- For production, consider managing DNS via Terraform too
- Works well with Git versioning and remote Terraform state if needed

## 📮 Feedback & Contributions

Feel free to open issues or suggest improvements.  
If you'd like to extend this to support Ingress or other apps alongside AWX – modularity is welcome!
