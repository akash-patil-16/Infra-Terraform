output "name" {
  description = "Virtual machine name."
  value       = azurerm_linux_virtual_machine.this.name
}

output "private_ip_address" {
  description = "Private IP assigned to the virtual machine network interface."
  value       = azurerm_network_interface.this.private_ip_address
}

output "network_interface_id" {
  description = "Network interface resource ID."
  value       = azurerm_network_interface.this.id
}