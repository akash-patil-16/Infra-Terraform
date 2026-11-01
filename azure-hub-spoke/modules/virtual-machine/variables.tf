variable "name" {
  description = "Linux virtual machine name."
  type        = string
}

variable "network_interface_name" {
  description = "Network interface name attached to the virtual machine."
  type        = string
}

variable "location" {
  description = "Azure region for the virtual machine and its network interface."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing the virtual machine and its network interface."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the VM network interface."
  type        = string
}

variable "size" {
  description = "Azure VM size."
  type        = string
}

variable "admin_username" {
  description = "Linux administrator account name."
  type        = string
}

variable "admin_password" {
  description = "Linux administrator password."
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags applied to the virtual machine and network interface."
  type        = map(string)
  default     = {}
}