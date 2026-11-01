variable "name" {
  description = "Azure Bastion host name."
  type        = string
}

variable "location" {
  description = "Azure region for the Bastion host and its public IP."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing the Bastion host and its public IP."
  type        = string
}

variable "subnet_id" {
  description = "ID of the dedicated AzureBastionSubnet in the hub VNet."
  type        = string
}

variable "sku" {
  description = "Azure Bastion SKU."
  type        = string
  default     = "Standard"
}

variable "tags" {
  description = "Tags applied to Bastion resources."
  type        = map(string)
  default     = {}
}