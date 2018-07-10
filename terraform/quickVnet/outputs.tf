# -----------------------------------------------------------------------------
# place the outputs of interest into the remote state
# -----------------------------------------------------------------------------
# vnet name output
output "vnet_name" {
  value = "${azurerm_virtual_network.vnet.name}"
}

# vnet location output
output "vnet_location" {
  value = "${azurerm_virtual_network.vnet.location}"
}

# vnet address space output
output "vnet_address_space" {
  value = "${azurerm_virtual_network.vnet.address_space}"
}

output "subnet_id" {
  value = "${azurerm_subnet.subnet.id}"
}

output "subnet_name" {
  value = "${azurerm_subnet.subnet.name}"
}

output "subnet_prefix" {
  value = "${azurerm_subnet.subnet.address_prefix}"
}
