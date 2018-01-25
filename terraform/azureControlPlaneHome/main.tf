# -----------------------------------------------------------------------------
# resourceGroup configuration
# -----------------------------------------------------------------------------
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = "${var.location}"
  tags     = "${var.tags}"
}

# -----------------------------------------------------------------------------
# vnet configuration
# -----------------------------------------------------------------------------
module "network" "azureControlPlaneNetwork" {
  source              = "github.com/Azure/terraform-azurerm-network"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${var.location}"
  address_space       = "${var.address_space}"
  subnet_prefixes     = ["${var.subnet_prefixes}"]
  subnet_names        = ["${var.subnet_names}"]
  vnet_name           = "azureControlPlaneNetwork"
  tags     = "${var.tags}"
}
