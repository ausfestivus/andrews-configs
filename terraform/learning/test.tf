provider "azurerm" {
}

resource "azurerm_resource_group" "rg" {
        name = "testResourceGroup"
        location = "westus2"
}

resource "azurerm_storage_account" "logstrggrp" {
  # name = "absglogs"
  # location = "${var.location}"
  # resource_group_name = "${azurerm_resource_group.rg.name}"
  # account_kind = "StorageV2"
  # account_tier = "Standard"
  # account_replication_type = "LRS"
  # #access_tier = "Hot"
  # tags = "${var.tags}"
  name = "absglogs"
  location = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  account_kind = "StorageV2"
  account_tier = "Standard"
  account_replication_type = "LRS"
  tags = "${var.tags}"
}
