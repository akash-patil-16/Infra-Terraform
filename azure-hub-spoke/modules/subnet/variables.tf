variable "name" {
  description = "Subnet name."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing the virtual network."
  type        = string
}

variable "virtual_network_name" {
  description = "Virtual network containing the subnet."
  type        = string
}

variable "address_prefixes" {
  description = "Address prefixes assigned to the subnet."
  type        = list(string)
}