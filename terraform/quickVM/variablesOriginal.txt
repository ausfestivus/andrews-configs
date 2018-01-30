variable "prefix" {
  description = "Default prefix to use with your resource names."
  default = "quickVM"
}

variable "location" {
  description = "The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  #default = "australiaeast"
  default = "westus2"
}

variable "address_space" {
  description = "The address space that is used by the vNet."
  default     = "10.0.1.0/24"
}

# If no values specified, this defaults to Azure DNS
variable "dns_servers" {
  description = "The DNS servers to be used with vNet"
  default     = []
}

variable "subnet_prefixes" {
  description = "The address prefix to use for the subnet."
  #default     = ["10.0.1.0/26", "10.0.1.64/26", "10.0.1.128/26"]
  default     = ["10.0.1.0/26"]
}

variable "subnet_names" {
  description = "A list of subnets inside the vNet."
  default     = ["quickVM"]
}

# variable "sg_name" {
#   description = "The Security Group name inside the vNet."
#   default     = "jiraConfluence-nsg"
# }

variable "cmd_extension" {
  description = "Command to be excuted by the custom script extension"
  default     = ""
}

variable "cmd_script" {
  description = "Script to download which can be executed by the custom script extension"
  default = ""
}

variable "tags" {
  type = "map"
  default = {
    environment = "dev"
    zone = "lab"
    project = "quickVM"
  }
}

variable "ssh_key_public" {}

variable "ssh_key_private" {}

variable "ubuntu_user_secret" {}

variable "mssql_user_secret" {}
