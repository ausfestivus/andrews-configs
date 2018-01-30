# -----------------------------------------------------------------------------
# resourceGroup configuration
# -----------------------------------------------------------------------------
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group}-rg"
  location = "${var.location}"
  tags     = "${var.tags}"

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

resource "azurerm_subnet" "subnet" {
  name                 = "${var.rg_prefix}-subnet"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "${var.subnet_prefix}"
}

# -----------------------------------------------------------------------------
# nsg configuration
# -----------------------------------------------------------------------------
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.rg_prefix}-nsg"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  tags                = "${var.tags}"
}

resource "azurerm_network_security_rule" "ssh_access" {
  name                        = "ssh-access-rule"
  network_security_group_name = "${azurerm_network_security_group.nsg.name}"
  resource_group_name         = "${azurerm_resource_group.rg.name}"
  direction                   = "Inbound"
  access                      = "Allow"
  priority                    = 200
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_address_prefixes  = ["${var.subnet_prefix}"]
  destination_port_range      = "22"
  protocol                    = "TCP"
}

# -----------------------------------------------------------------------------
# Linux vm configuration
# -----------------------------------------------------------------------------

resource "azurerm_network_interface" "nic" {
  name                = "${var.rg_prefix}-nic"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "${var.rg_prefix}-ipconfig"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.pip.id}"
  }
  tags                = "${var.tags}"

}

resource "azurerm_public_ip" "pip" {
  name                         = "${var.rg_prefix}-pip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "Dynamic"
  domain_name_label            = "${var.dns_name}"
  tags                         = "${var.tags}"

}

# resource "azurerm_storage_account" "stor" {
#   name                     = "${var.dns_name}-stor"
#   location                 = "${var.location}"
#   resource_group_name      = "${azurerm_resource_group.rg.name}"
#   account_tier             = "${var.storage_account_tier}"
#   account_replication_type = "${var.storage_replication_type}"
# }

resource "azurerm_managed_disk" "datadisk" {
  name                 = "${var.hostname}-datadisk"
  location             = "${var.location}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1023"
  tags                 = "${var.tags}"
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.rg_prefix}-vm"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  vm_size               = "${var.vm_size}"
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]
  delete_os_disk_on_termination = true
  tags                  = "${var.tags}"


  storage_image_reference {
    publisher = "${var.image_publisher}"
    offer     = "${var.image_offer}"
    sku       = "${var.image_sku}"
    version   = "${var.image_version}"
  }

  storage_os_disk {
    name                          = "${var.hostname}-osdisk"
    managed_disk_type             = "Standard_LRS"
    caching                       = "ReadWrite"
    create_option                 = "FromImage"
  }

  storage_data_disk {
    name              = "${var.hostname}-datadisk"
    managed_disk_id   = "${azurerm_managed_disk.datadisk.id}"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = "1023"
    create_option     = "Attach"
    lun               = 0
  }

  os_profile {
    computer_name  = "${var.hostname}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.ubuntu_user_secret}"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/ubuntu/.ssh/authorized_keys"
      key_data = "${var.ssh_key_public}"
    }

  }

  # boot_diagnostics {
  #   enabled     = false
  #   storage_uri = "${azurerm_storage_account.stor.primary_blob_endpoint}"
  # }
}
