output "id" {
  description = "Azure Bastion host resource ID."
  value       = azurerm_bastion_host.this.id
}

output "name" {
  description = "Azure Bastion host name."
  value       = azurerm_bastion_host.this.name
}

output "public_ip_address" {
  description = "Public IP address assigned to the Bastion host."
  value       = azurerm_public_ip.this.ip_address
}

output "public_ip_address_id" {
  description = "Resource ID of the Bastion public IP address."
  value       = azurerm_public_ip.this.id
}