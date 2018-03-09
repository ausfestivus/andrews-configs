variable "rg_prefix" {
  description = "The shortened abbreviation to represent your resource group that will go on the front of some resources."
  default     = "quickVNET"
}

variable "location" {
  description = "The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  #default = "australiaeast"
  default = "westus2"
}

variable "resource_group" {
  description = "The name of the resource group in which to create the virtual network."
  default = "quickVNET"
}

# variable "hostname" {
#   description = "VM name referenced also in storage-related names."
#   default     = "quickVM"
# }
#
# variable "dns_name" {
#   description = " Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system."
#   default     = "quickvm"
# }

variable "virtual_network_name" {
  description = "The name for the virtual network."
  default     = "quickVNET"
}

variable "address_space" {
  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
  default     = "192.168.0.0/16"
}

variable "subnet_prefix" {
  description = "The address prefix to use for the subnet."
  default     = "192.168.254.0/24"
}

variable "tags" {
  type = "map"
  default = {
    environment = "dev"
    zone = "lab"
    project = "quickVNET"
  }
}
