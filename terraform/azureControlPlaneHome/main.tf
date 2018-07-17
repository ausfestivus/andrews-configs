# -----------------------------------------------------------------------------
# resourceGroup configuration
# -----------------------------------------------------------------------------
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = "${var.location}"
  tags     = "${var.tags}"
}

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
    key                  = "abconf.terraform.azureControlPlaneHome"
  }
}

# -----------------------------------------------------------------------------
# vnet configuration
# -----------------------------------------------------------------------------
module "network" "azureControlPlaneNetwork" {
  #source              = "github.com/Azure/terraform-azurerm-network"
  source              = "Azure/network/azurerm"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${var.location}"
  address_space       = "${var.address_space}"
  subnet_prefixes     = ["${var.subnet_prefixes}"]
  subnet_names        = ["${var.subnet_names}"]
  vnet_name           = "${var.prefix}-vNet"
  tags                = "${var.tags}"
}
