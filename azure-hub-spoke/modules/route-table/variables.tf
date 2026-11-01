variable "name" {
  description = "Route table name."
  type        = string
}

variable "location" {
  description = "Azure region for the route table."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing the route table."
  type        = string
}

variable "subnet_id" {
  description = "Subnet to associate with the route table."
  type        = string
}

variable "next_hop_ip" {
  description = "Optional private IP of the future firewall next hop. Null omits the default route."
  type        = string
  default     = null
  nullable    = true
}

variable "tags" {
  description = "Tags applied to the route table."
  type        = map(string)
  default     = {}
}