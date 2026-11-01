variable "location" {
  description = "Azure region for all resources."
  type        = string
}

variable "tags" {
  description = "Tags applied to all supported resources."
  type        = map(string)
  default     = {}
}

variable "resource_groups" {
  description = "Resource groups keyed by logical role."
  type = map(object({
    name = string
  }))
}

variable "virtual_networks" {
  description = "Virtual networks keyed by logical role."
  type = map(object({
    name           = string
    resource_group = string
    address_space  = list(string)
  }))
}

variable "subnets" {
  description = "Subnets keyed by logical role. Each subnet belongs to one configured virtual network."
  type = map(object({
    name             = string
    virtual_network  = string
    address_prefixes = list(string)
  }))
}

variable "spoke_vnet_keys" {
  description = "Keys of the spoke virtual networks in var.virtual_networks."
  type        = set(string)
}

variable "admin_username" {
  description = "Administrator username configured on both Linux virtual machines."
  type        = string
}

variable "admin_password" {
  description = "Administrator password configured on both Linux virtual machines. Supply through TF_VAR_admin_password."
  type        = string
  sensitive   = true
}

variable "virtual_machines" {
  description = "Linux virtual machines keyed by logical role."
  type = map(object({
    name   = string
    subnet = string
    size   = string
  }))
}

variable "bastions" {
  description = "Azure Bastion hosts keyed by logical role."
  type = map(object({
    name   = string
    subnet = string
    sku    = optional(string, "Standard")
  }))
  default = {}
}


variable "firewall_next_hop_ip" {
  description = "Optional private IP for a future Azure Firewall. When null, no default route is created."
  type        = string
  default     = null
  nullable    = true
}