variable "prefix" {
  description = "Default prefix to use with your resource names."
  default = "sgtesting"
}

# -----------------------------------------------------------------------------
# network configuration
# -----------------------------------------------------------------------------
variable "location" {
  description = "The location/region where the solution will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  #default = "australiaeast"
  default = "westus2"
}

# variable "address_space" {
#   description = "The address space that is used by the vNet."
#   default     = "10.0.1.0/24"
# }
#
# # If no values specified, this defaults to Azure DNS
# variable "dns_servers" {
#   description = "The DNS servers to be used with vNet"
#   default     = []
# }
#
# variable "subnet_prefixes" {
#   description = "The address prefix to use for the subnet."
#   default     = ["10.0.1.0/26", "10.0.1.64/26", "10.0.1.128/26"]
# }
#
# variable "subnet_names" {
#   description = "A list of subnets inside the vNet."
#   default     = ["jiraConfluencePublic", "jiraConfluenceApp", "jiraConfluenceDB"]
# }

# # -----------------------------------------------------------------------------
# # database configuration
# # -----------------------------------------------------------------------------
# variable "jiradb_name" {
#   description = "The name to give the JIRA database."
#   default     = "jiradb"
# }
#
# variable "confluencedb_name" {
#   description = "The name to give the Confluence database."
#   default     = "confluencedb"
# }
#
# # -----------------------------------------------------------------------------
# # vm configuration
# # -----------------------------------------------------------------------------
# variable "admin_username" {
#   description = "administrator user name"
#   default     = "ubuntu"
# }
#
# variable "vm_size" {
#   description = "Specifies the size of the virtual machine."
#   default     = "Standard_DS1_v2"
# }
#
# variable "image_publisher" {
#   description = "name of the publisher of the image (az vm image list)"
#   default     = "Canonical"
# }
#
# variable "image_offer" {
#   description = "the name of the offer (az vm image list)"
#   default     = "UbuntuServer"
# }
#
# variable "image_sku" {
#   description = "image sku to apply (az vm image list)"
#   default     = "16.04-LTS"
# }
#
# variable "image_version" {
#   description = "version of the image to apply (az vm image list)"
#   default     = "latest"
# }
#
# variable "parent_zone" {
#   description = "the parent DNS zone this VM will create a CNAME record under"
#   default     = "cloud00.bestfamily.id.au"
# }
#
# # variable "bastion_hostname" {
# #   description = "The hostname to give the bastion server."
# #   default     = "diatjmp00"
# # }
#
# variable "jira_hostname" {
#   description = "The hostname to give the JIRA server."
#   default     = "diatapp00"
# }
#
# variable "confluence_hostname" {
#   description = "The hostname to give the Confluence server."
#   default     = "diatapp01"
# }
#
# -----------------------------------------------------------------------------
# other configuration
# -----------------------------------------------------------------------------
variable "tags" {
  type = "map"
  default = {
    environment = "dev"
    zone = "lab"
    project = "learning"
  }
}
#
# # variable "ssh_key_public" {}
# #
# # variable "ssh_key_private" {}
# #
# # variable "ubuntu_user_secret" {}
# #
# # variable "mssql_user_secret" {}
