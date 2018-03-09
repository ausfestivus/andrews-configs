variable "rg_prefix" {
  description = "The shortened abbreviation to represent your resource group that will go on the front of some resources."
  default     = "VMonly"
}

variable "location" {
  description = "The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  #default = "australiaeast"
  default = "westus2"
}

variable "resource_group" {
  description = "The name of the resource group in which to create the virtual network."
  default = "VMonly"
}

variable "hostname" {
  description = "VM name referenced also in storage-related names."
  default     = "VMonly"
}

variable "dns_name" {
  description = " Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system."
  default     = "vmonly"
}

# variable "virtual_network_name" {
#   description = "The name for the virtual network."
#   default     = "quickVM"
# }
#
# variable "address_space" {
#   description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
#   default     = "192.168.0.0/16"
# }
#
# variable "subnet_prefix" {
#   description = "The address prefix to use for the subnet."
#   default     = "192.168.254.0/24"
# }

variable "storage_account_tier" {
  description = "Defines the Tier of storage account to be created. Valid options are Standard and Premium."
  default     = "Standard"
}

variable "storage_replication_type" {
  description = "Defines the Replication Type to use for this storage account. Valid options include LRS, GRS etc."
  default     = "LRS"
}

variable "vm_size" {
  description = "Specifies the size of the virtual machine."
  default     = "Standard_A0"
}

variable "image_publisher" {
  description = "name of the publisher of the image (az vm image list)"
  default     = "Canonical"
}

variable "image_offer" {
  description = "the name of the offer (az vm image list)"
  default     = "UbuntuServer"
}

variable "image_sku" {
  description = "image sku to apply (az vm image list)"
  default     = "16.04-LTS"
}

variable "image_version" {
  description = "version of the image to apply (az vm image list)"
  default     = "latest"
}

variable "parent_zone" {
  description = "the parent DNS zone this VM will create a CNAME record under"
  default     = "cloud00.bestfamily.id.au"
}

variable "tags" {
  type = "map"
  default = {
    environment = "dev"
    zone = "lab"
    project = "quickVM"
  }
}

variable "admin_username" {
  description = "administrator user name"
  default     = "ubuntu"
}

variable "ssh_key_public" {}

variable "ssh_key_private" {}

variable "ubuntu_user_secret" {}

variable "mssql_user_secret" {}
