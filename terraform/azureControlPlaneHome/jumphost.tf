# -----------------------------------------------------------------------------
# "jumpvm" configuration
# -----------------------------------------------------------------------------

resource "azurerm_public_ip" "jumpvm" {
  name                         = "${var.jumpvm_hostname}-pip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "Dynamic"
  domain_name_label            = "${var.jumpvm_hostname}"
  tags                         = "${var.tags}"
}

resource "azurerm_network_security_group" "jumpvm" {
  name                = "${var.jumpvm_hostname}-ssh-access"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  tags                = "${var.tags}"
}

resource "azurerm_network_security_rule" "ssh_access" {
  name                        = "ssh-access-rule"
  network_security_group_name = "${azurerm_network_security_group.jumpvm.name}"
  direction                   = "Inbound"
  access                      = "Allow"
  priority                    = 200
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_address_prefix  = "${azurerm_network_interface.jumpvm.private_ip_address}"
  destination_port_range      = "22"
  protocol                    = "TCP"
  resource_group_name         = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_network_security_rule" "https_access" {
  name                        = "www-access-rule"
  network_security_group_name = "${azurerm_network_security_group.jumpvm.name}"
  direction                   = "Inbound"
  access                      = "Allow"
  priority                    = 201
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_address_prefix  = "${azurerm_network_interface.jumpvm.private_ip_address}"

  #destination_port_range      = "443"
  destination_port_ranges = ["80", "443"]
  protocol                = "TCP"
  resource_group_name     = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_network_interface" "jumpvm" {
  name                      = "${var.jumpvm_hostname}-nic"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  network_security_group_id = "${azurerm_network_security_group.jumpvm.id}"

  ip_configuration {
    name                          = "IPConfiguration"
    subnet_id                     = "${module.network.vnet_subnets[0]}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.jumpvm_private_ip}"
    public_ip_address_id          = "${azurerm_public_ip.jumpvm.id}"
  }

  tags = "${var.tags}"
}

resource "azurerm_virtual_machine" "jumpvm" {
  name                          = "${var.jumpvm_hostname}-vm"
  location                      = "${var.location}"
  resource_group_name           = "${azurerm_resource_group.rg.name}"
  network_interface_ids         = ["${azurerm_network_interface.jumpvm.id}"]
  vm_size                       = "${var.vm_size}"
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "${var.image_publisher}"
    offer     = "${var.image_offer}"
    sku       = "${var.image_sku}"
    version   = "${var.image_version}"
  }

  storage_os_disk {
    name              = "jumpvm-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.jumpvm_hostname}"
    admin_username = "${var.admin_username}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/ubuntu/.ssh/authorized_keys"
      key_data = "${var.ssh_key_public}"
    }
  }

  tags = "${var.tags}"
}

resource "azurerm_dns_cname_record" "jumpvm" {
  name                = "${var.jumpvm_hostname}"
  zone_name           = "${var.dns_zone_name}"
  resource_group_name = "${var.dns_zone_rg}"
  ttl                 = 300
  record              = "${azurerm_public_ip.jumpvm.fqdn}"
}
