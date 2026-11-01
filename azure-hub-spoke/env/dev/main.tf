locals {
  common_tags = merge(var.tags, {
    managed_by = "terraform"
    project    = "azure-hub-spoke"
  })

  peerings = {
    for peering in flatten([
      for spoke_key in var.spoke_vnet_keys : [
        {
          key         = "hub_to_${spoke_key}"
          name        = "peer-hub-to-${spoke_key}"
          local_vnet  = "hub"
          remote_vnet = spoke_key
        },
        {
          key         = "${spoke_key}_to_hub"
          name        = "peer-${spoke_key}-to-hub"
          local_vnet  = spoke_key
          remote_vnet = "hub"
        }
      ]
    ]) : peering.key => peering
  }
}

module "resource_groups" {
  source   = "./modules/resource-group"
  for_each = var.resource_groups

  name     = each.value.name
  location = var.location
  tags     = local.common_tags
}

module "virtual_networks" {
  source   = "./modules/virtual-network"
  for_each = var.virtual_networks

  name                = each.value.name
  location            = var.location
  resource_group_name = module.resource_groups[each.value.resource_group].name
  address_space       = each.value.address_space
  tags                = local.common_tags
}

module "subnets" {
  source   = "./modules/subnet"
  for_each = var.subnets

  name                 = each.value.name
  resource_group_name  = module.resource_groups[var.virtual_networks[each.value.virtual_network].resource_group].name
  virtual_network_name = module.virtual_networks[each.value.virtual_network].name
  address_prefixes     = each.value.address_prefixes
}

module "network_security_groups" {
  source   = "./modules/network-security-group"
  for_each = var.virtual_machines

  name                = "${each.value.name}-nsg"
  location            = var.location
  resource_group_name = module.resource_groups[var.virtual_networks[var.subnets[each.value.subnet].virtual_network].resource_group].name
  subnet_id           = module.subnets[each.value.subnet].id
  security_rules = [
    {
      name                       = "allow-all"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
  tags = local.common_tags
}

module "virtual_machines" {
  source   = "./modules/virtual-machine"
  for_each = var.virtual_machines

  name                   = each.value.name
  network_interface_name = "${each.value.name}-nic"
  location               = var.location
  resource_group_name    = module.resource_groups[var.virtual_networks[var.subnets[each.value.subnet].virtual_network].resource_group].name
  subnet_id              = module.subnets[each.value.subnet].id
  size                   = each.value.size
  admin_username         = var.admin_username
  admin_password         = var.admin_password
  tags                   = local.common_tags

  depends_on = [module.network_security_groups]
}

module "vnet_peerings" {
  source   = "./modules/vnet-peering"
  for_each = local.peerings

  name                       = each.value.name
  resource_group_name        = module.resource_groups[var.virtual_networks[each.value.local_vnet].resource_group].name
  local_virtual_network_name = module.virtual_networks[each.value.local_vnet].name
  remote_virtual_network_id  = module.virtual_networks[each.value.remote_vnet].id
  allow_forwarded_traffic    = true
}

module "route_tables" {
  source = "./modules/route-table"
  for_each = {
    for key, subnet in var.subnets : key => subnet
    if contains(var.spoke_vnet_keys, subnet.virtual_network)
  }

  name                = "${each.value.name}-rt"
  location            = var.location
  resource_group_name = module.resource_groups[var.virtual_networks[each.value.virtual_network].resource_group].name
  subnet_id           = module.subnets[each.key].id
  next_hop_ip         = var.firewall_next_hop_ip
  tags                = local.common_tags
}