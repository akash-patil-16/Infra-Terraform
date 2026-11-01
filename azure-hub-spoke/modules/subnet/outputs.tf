output "id" {
  description = "Subnet resource ID."
  value       = azurerm_subnet.this.id
}

output "name" {
  description = "Subnet name."
  value       = azurerm_subnet.this.name
}