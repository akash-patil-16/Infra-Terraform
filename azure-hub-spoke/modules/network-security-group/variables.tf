variable "name" {
  description = "Network security group name."
  type        = string
}

variable "location" {
  description = "Azure region for the network security group."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing the network security group."
  type        = string
}

variable "subnet_id" {
  description = "Subnet to associate with this network security group."
  type        = string
}

variable "security_rules" {
  description = "Security rules to configure on the network security group."
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = []
}

variable "tags" {
  description = "Tags applied to the network security group."
  type        = map(string)
  default     = {}
}