# -----------------------------------------------------------------------------
# vnet configuration
# -----------------------------------------------------------------------------

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = "${var.location}"
  tags     = "${var.tags}"
}

# resource "azurerm_virtual_network" "vnet" {
#   name                = "${var.prefix}-vnet"
#   location            = "${var.location}"
#   address_space       = ["${var.address_space}"]
#   resource_group_name = "${azurerm_resource_group.rg.name}"
#   dns_servers         = "${var.dns_servers}"
#   tags                = "${var.tags}"
# }
#
# resource "azurerm_subnet" "subnet" {
#   name                      = "${var.subnet_names[count.index]}"
#   virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
#   resource_group_name       = "${azurerm_resource_group.rg.name}"
#   address_prefix            = "${var.subnet_prefixes[count.index]}"
#   network_security_group_id = "${azurerm_network_security_group.security_group.id}"
#   count                     =  "${length(var.subnet_names)}"
# }

module "network" "azureControlPlaneNetwork" {
  source              = "github.com/Azure/terraform-azurerm-network"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${var.location}"
  address_space       = "${var.address_space}"
  subnet_prefixes     = ["${var.subnet_prefixes}"]
  subnet_names        = ["${var.subnet_names}"]
  vnet_name           = "azureControlPlaneNetwork"
}

resource "azurerm_network_security_group" "security_group" {
  name                  = "${var.prefix}-secgrp"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  tags                  = "${var.tags}"
}

# resource "azurerm_network_security_rule" "security_rule_rdp" {
#   name                        = "rdp"
#   priority                    = 101
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "3389"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = "${azurerm_resource_group.rg.name}"
#   network_security_group_name = "${azurerm_network_security_group.security_group.name}"
# }

resource "azurerm_network_security_rule" "security_rule_ssh" {
  name                        = "ssh"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.security_group.name}"
}

# -----------------------------------------------------------------------------
# "jumpbox" configuration
# -----------------------------------------------------------------------------

resource "azurerm_public_ip" "jumpbox" {
  name                         = "jumpbox-public-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "static"
  domain_name_label            = "${azurerm_resource_group.rg.name}-ssh"
  tags                         = "${var.tags}"
  # tags {
  #   environment = "dev"
  # }
}

resource "azurerm_network_security_group" "jumpbox" {
  name                = "jumpbox-ssh-access"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  tags                = "${var.tags}"
}

resource "azurerm_network_security_rule" "ssh_access" {
  name                        = "ssh-access-rule"
  network_security_group_name = "${azurerm_network_security_group.jumpbox.name}"
  direction                   = "Inbound"
  access                      = "Allow"
  priority                    = 200
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_address_prefix  = "${azurerm_network_interface.jumpbox.private_ip_address}"
  destination_port_range      = "22"
  protocol                    = "TCP"
  resource_group_name         = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_network_interface" "jumpbox" {
  name                      = "jumpbox-nic"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  network_security_group_id = "${azurerm_network_security_group.jumpbox.id}"

  ip_configuration {
    name                          = "IPConfiguration"
    subnet_id                     = "${module.network.vnet_subnets[0]}"
    #subnet_id                     = "${azurerm_subnet.subnet.id[0]}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.jumpbox.id}"
  }

  tags                      = "${var.tags}"
  # tags {
  #   environment = "dev"
  # }
}

resource "azurerm_virtual_machine" "jumpbox" {
  name                          = "jumpbox"
  location                      = "${var.location}"
  resource_group_name           = "${azurerm_resource_group.rg.name}"
  network_interface_ids         = ["${azurerm_network_interface.jumpbox.id}"]
  vm_size                       = "Standard_DS1_v2"
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "jumpbox-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "jumpbox"
    admin_username = "azureuser"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = "${var.ssh_key_public}"
    }
  }

  tags                          = "${var.tags}"
  # tags {
  #   environment = "dev"
  # }
}
