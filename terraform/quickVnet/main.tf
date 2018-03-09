# -----------------------------------------------------------------------------
# remote state Saving
# https://www.terraform.io/docs/backends/types/azurerm.html
# -----------------------------------------------------------------------------
# storage account RG: terraformstate-rg
# storage account name: terraformstatesg
# container name: tfstate
# key: abconf.terraform.quickVnetState
terraform {
  backend "azurerm" {
    resource_group_name  = "terraformstate-rg"
    storage_account_name = "terraformstatesg"
    container_name       = "tfstate"
    key                  = "abconf.terraform.quickVnetState"
  }
}

# -----------------------------------------------------------------------------
# resourceGroup configuration
# -----------------------------------------------------------------------------
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group}-rg"
  location = "${var.location}"
  tags     = "${var.tags}"
}

# Other configurations will depend on this underlying config so we need to
# output some values to our remote state for others to use.

output "resource_group_name" {
  value = "${azurerm_resource_group.rg.name}"
}

# -----------------------------------------------------------------------------
# vnet configuration
# -----------------------------------------------------------------------------
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.virtual_network_name}-vnet"
  location            = "${var.location}"
  address_space       = ["${var.address_space}"]
  resource_group_name = "${azurerm_resource_group.rg.name}"
  tags                = "${var.tags}"
}

# vnet name output
output "vnet_name" {
  value = "${azurerm_virtual_network.vnet.name}"
}

# vnet location output
output "vnet_location" {
  value = "${azurerm_virtual_network.vnet.location}"
}

# vnet address space
output "vnet_address_space" {
  value = ["${azurerm_virtual_network.vnet.address_space}"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.rg_prefix}-subnet"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "${var.subnet_prefix}"
}

# subnet name output

# subnet address prefix

# -----------------------------------------------------------------------------
# nic configuration
# -----------------------------------------------------------------------------
#
# README
# To import a subnet into Terraform, the Resource ID of the subnet object is
# required. BUT, the subnet doesnt actually exist UNTIL a network card is
# is attached to it. See:
# https://stackoverflow.com/questions/36289702/why-is-the-id-for-a-subnet-created-using-azure-resource-manager-powershell-cmdle
# So, here, we create a single NIC and attach it to the vnet JUST to get
# the Subnet ID created.

# resource "azurerm_network_interface" "nic" {
#   name                = "${var.rg_prefix}-nic"
#   location            = "${var.location}"
#   resource_group_name = "${azurerm_resource_group.rg.name}"
#
#   ip_configuration {
#     name                          = "${var.rg_prefix}-ipconfig"
#     subnet_id                     = "${azurerm_subnet.subnet.id}"
#     private_ip_address_allocation = "Dynamic"
#     # public_ip_address_id          = "${azurerm_public_ip.pip.id}"
#   }
#   tags                = "${var.tags}"
#
# }
