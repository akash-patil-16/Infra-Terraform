output "hub_vnet_id" {
  description = "Resource ID of the hub virtual network."
  value       = module.virtual_networks["hub"].id
}

output "spoke_vnet_id" {
  description = "Resource ID of the spoke virtual network."
  value       = module.virtual_networks["spoke"].id
}

output "spoke_vnet_ids" {
  description = "Resource IDs of all spoke virtual networks, keyed by logical role."
  value       = { for key in var.spoke_vnet_keys : key => module.virtual_networks[key].id }
}

output "hub_subnet_ids" {
  description = "Subnet IDs belonging to the hub virtual network, keyed by logical subnet name."
  value = {
    for key, subnet in var.subnets : key => module.subnets[key].id
    if subnet.virtual_network == "hub"
  }
}

output "spoke_subnet_ids" {
  description = "Subnet IDs belonging to the spoke virtual network, keyed by logical subnet name."
  value = {
    for key, subnet in var.subnets : key => module.subnets[key].id
    if contains(var.spoke_vnet_keys, subnet.virtual_network)
  }
}

output "vm_names" {
  description = "Names of the created virtual machines."
  value       = { for key, vm in module.virtual_machines : key => vm.name }
}

output "vm_private_ip_addresses" {
  description = "Private IP addresses assigned to the virtual machines."
  value       = { for key, vm in module.virtual_machines : key => vm.private_ip_address }
}

output "nic_ids" {
  description = "Network interface IDs attached to the virtual machines."
  value       = { for key, vm in module.virtual_machines : key => vm.network_interface_id }
}

output "vnet_peering_ids" {
  description = "IDs of the hub-to-spoke and spoke-to-hub peerings."
  value       = { for key, peering in module.vnet_peerings : key => peering.id }
}