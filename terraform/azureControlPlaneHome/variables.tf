# -----------------------------------------------------------------------------
# resource group configuration
# -----------------------------------------------------------------------------

variable "prefix" {
  description = "Default prefix to use with your resource names."
  default     = "azurecontrolplanehome"
}

variable "location" {
  description = "The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  default     = "westus2"
}

variable "tags" {
  type = "map"

  default = {
    environment = "prod"
    zone        = "controlplane"
    terraform   = "true"
  }
}

# -----------------------------------------------------------------------------
# network configuration
# -----------------------------------------------------------------------------
variable "address_space" {
  description = "The address space that is used by the Control Plane network."
  default     = "10.0.0.0/24"
}

# If no values specified, this defaults to Azure DNS
variable "dns_servers" {
  description = "The DNS servers to be used with vNet"
  default     = []
}

variable "subnet_prefixes" {
  description = "The address prefix to use for the subnet."
  default     = ["10.0.0.0/26", "10.0.0.192/26"]
}

variable "subnet_names" {
  description = "A list of public subnets inside the vNet."
  default     = ["subnet0", "GatewaySubnet"]
}

# -----------------------------------------------------------------------------
# security group configuration
# -----------------------------------------------------------------------------
variable "sg_name" {
  description = "The Security Group name inside the vNet."
  default     = "ctrlpln-nsg"
}

# -----------------------------------------------------------------------------
# vm configuration
# -----------------------------------------------------------------------------
variable "admin_username" {
  description = "administrator user name"
  default     = "ubuntu"
}

variable "vm_size" {
  description = "Specifies the size of the virtual machine."
  default     = "Standard_DS1_v2"
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

variable "dns_zone_name" {
  # the parent DNS zone this VM will create a CNAME record under
  description = "the parent DNS zone this VM will create a CNAME record under"
  default     = "cloud00.bestfamily.id.au"
}

variable "dns_zone_rg" {
  # The resource group name that the above DNS domain is in.
  description = "The resource group name that the above DNS domain is in."
  default     = "rgDNSZones"
}

variable "jumpvm_hostname" {
  description = ""
  default     = "jump00"
}

variable "jumpvm_private_ip" {
  description = ""
  default     = "10.0.0.10"
}

variable "jumpvm_servicename" {
  description = ""
  default     = "jump"
}

# -----------------------------------------------------------------------------
# Shared State Storage configuration
# -----------------------------------------------------------------------------

# variable "shared_storage_account_name" {}
#
# variable "shared_storage_container_name" {}
#
# variable "shared_storage_key" {}
#
# variable "shared_storage_access_key" {}

variable "ssh_key_public" {}

variable "ssh_key_private" {}

variable "ubuntu_user_secret" {}

variable "mssql_user_secret" {}
