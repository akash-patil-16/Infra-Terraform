variable "name" {
  description = "VNet peering name."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing the local virtual network."
  type        = string
}

variable "local_virtual_network_name" {
  description = "Name of the local virtual network."
  type        = string
}

variable "remote_virtual_network_id" {
  description = "Resource ID of the remote virtual network."
  type        = string
}

variable "allow_forwarded_traffic" {
  description = "Whether forwarded traffic is allowed from the remote virtual network."
  type        = bool
  default     = true
}