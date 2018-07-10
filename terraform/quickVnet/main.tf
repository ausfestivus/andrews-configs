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
# output "resource_group_name" {
#   value = "${azurerm_resource_group.rg.name}"
# }

# -----------------------------------------------------------------------------
# vnet configuration
# -----------------------------------------------------------------------------
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.resource_group}-vnet"
  location            = "${var.location}"
  address_space       = ["${var.address_space}"]
  resource_group_name = "${azurerm_resource_group.rg.name}"
  tags                = "${var.tags}"
}

# -----------------------------------------------------------------------------
# subnet configuration
# -----------------------------------------------------------------------------
resource "azurerm_subnet" "subnet" {
  name                 = "${var.resource_group}-subnet"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "${var.subnet_prefix}"
}
