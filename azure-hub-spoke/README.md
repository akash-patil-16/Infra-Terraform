# Azure Hub-and-Spoke Network

This Terraform project creates a hub VNet and two spoke VNets, bidirectional hub-to-spoke peering, an Azure Bastion host in the hub, and two Ubuntu Linux VMs in isolated spoke subnets. It does not deploy Azure Firewall or a VPN Gateway. The Bastion host has a public IP; the VMs do not.

The spoke subnet route tables are associated at deployment. By default they contain no custom route; setting `firewall_next_hop_ip` adds a `0.0.0.0/0` route via an existing Azure Firewall private IP. Configure that IP only after the firewall and its network path are ready, since this route redirects all spoke egress.

## Architecture

- Hub: `rg-hub-network` / `vnet-hub` (`10.0.0.0/16`) with `AzureFirewallSubnet`, `GatewaySubnet`, and `snet-hub-management`.
- Azure Bastion is deployed into the dedicated `AzureBastionSubnet` with a Standard static public IP.
- Spokes: `rg-spoke-network` contains `vnet-spoke` (`10.1.0.0/16`) for web and `vnet-spoke2` (`10.2.0.0/16`) for app.
- Each spoke has peering to the hub in both directions with forwarded traffic enabled.
- Each VM has a dynamic private IP, NIC, system-assigned managed identity, Ubuntu 22.04 LTS image, and username/password authentication. No VM has a public IP.
- Each VM subnet gets an NSG allowing SSH only from the configured management CIDR.

## Folder Structure

```text
azure-hub-spoke/
  main.tf
  variables.tf
  outputs.tf
  providers.tf
  terraform.tfvars
  versions.tf
  modules/
    resource-group/
    virtual-network/
    subnet/
    virtual-machine/
    network-security-group/
    vnet-peering/
    route-table/
    bastion/
```

Each module contains `main.tf`, `variables.tf`, and `outputs.tf`.

## Prerequisites

- Terraform CLI 1.5 or later.
- Azure CLI and an Azure subscription with permission to create resource groups, networks, and virtual machines.
- A strong Linux administrator password that meets Azure's password complexity requirements.
- The selected Azure region must offer `Standard_B2s` and the Ubuntu image.

## Azure Authentication

Sign in and select the target subscription:

```powershell
az login
az account set --subscription "<subscription-id-or-name>"
```

AzureRM provider v4 reads the subscription from the active Azure CLI context or `ARM_SUBSCRIPTION_ID`. For service-principal or workload-identity authentication, configure the corresponding `ARM_*` environment variables as described in the AzureRM provider documentation. Do not put credentials in Terraform files.

## Configure

Edit `terraform.tfvars` before planning:

- Set `admin_username` to the desired Linux administrator account.
- Set `ssh_source_address_prefix` to the trusted management host/network CIDR that should reach SSH. The default allows only the hub management subnet.
- Set `firewall_next_hop_ip` to an existing firewall's private IP only when you intend to route all spoke egress through it; otherwise leave it `null`.
- Adjust `location` and tags as required.

Provide the password through the `TF_VAR_admin_password` environment variable rather than a Terraform file. In PowerShell, this prompts without echoing the entered password:

```powershell
$securePassword = Read-Host -Prompt "VM administrator password" -AsSecureString
$env:TF_VAR_admin_password = [System.Net.NetworkCredential]::new("", $securePassword).Password
```

After Terraform finishes, clear it from the current shell:

```powershell
Remove-Item Env:TF_VAR_admin_password
Remove-Variable securePassword
```

Terraform marks the input as sensitive, but Azure provider state can still contain the VM password. Use a secured, access-controlled remote state backend and protect state backups; do not commit state files or the password.

## Initialize and Validate

Run these commands from this directory:

```powershell
terraform fmt -recursive
terraform init
terraform validate
```

The provider constraint selects a compatible AzureRM 4.x release, and `.terraform.lock.hcl` should be committed after initialization.

## Plan and Apply

```powershell
terraform plan -out=tfplan
terraform apply tfplan
```

Review the plan carefully, especially any configured default routes, before applying. This project intentionally does not apply changes automatically.

## Outputs

Terraform outputs include the hub VNet ID, all spoke VNet IDs, subnet ID maps, VM names and private IPs, NIC IDs, peering IDs, and Bastion host/public IP information.

## Destroy

```powershell
terraform destroy
```

Destroy removes the resources managed by this Terraform state. Confirm that the state and target subscription are correct before proceeding.