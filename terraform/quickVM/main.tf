# main.tf
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
  vnet_name           = "vNet-${var.prefix}"
  tags                = "${var.tags}"
}

# -----------------------------------------------------------------------------
# nsg configuration
# -----------------------------------------------------------------------------
resource "azurerm_network_security_group" "quickVM" {
  name                = "${var.prefix}-nsg"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  tags                = "${var.tags}"
}

resource "azurerm_network_security_rule" "ssh_access" {
  name                        = "ssh-access-rule"
  network_security_group_name = "${azurerm_network_security_group.quickVM.name}"
  resource_group_name         = "${azurerm_resource_group.rg.name}"
  direction                   = "Inbound"
  access                      = "Allow"
  priority                    = 200
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_address_prefixes  = ["${var.subnet_prefixes}"]
  destination_port_range      = "22"
  protocol                    = "TCP"
}

# -----------------------------------------------------------------------------
# Linux vm configuration
# -----------------------------------------------------------------------------

resource "azurerm_public_ip" "quickVM" {
  name                          = "${var.prefix}-pip"
  location                      = "${var.location}"
  resource_group_name           = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation  = "dynamic"
  tags                          = "${var.tags}"
}

resource "azurerm_network_interface" "quickVM" {
  name                      = "${var.prefix}-nic"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  network_security_group_id = "${azurerm_network_security_group.quickVM.id}"

  ip_configuration {
    name                          = "IPConfiguration"
    subnet_id                     = "${module.network.vnet_subnets[0]}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.quickVM.id}"
  }
  tags                      = "${var.tags}"
}

resource "azurerm_virtual_machine" "quickVM" {
  name                          = "${var.prefix}-vm"
  location                      = "${var.location}"
  resource_group_name           = "${azurerm_resource_group.rg.name}"
  network_interface_ids         = ["${azurerm_network_interface.quickVM.id}"]
  vm_size                       = "Standard_DS1_v2"
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "quickVM-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "quickvm"
    admin_username = "ubuntu"
    admin_password = "${var.ubuntu_user_secret}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/ubuntu/.ssh/authorized_keys"
      key_data = "${var.ssh_key_public}"
    }
  }

  tags                          = "${var.tags}"
}

data "azurerm_public_ip" "quickVM" {
  name                = "${azurerm_public_ip.quickVM.name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  depends_on          = ["azurerm_virtual_machine.quickVM"]
}

output "jumpbox_public_ip" {
  description = "public IP address of the quickVM server"
  value       = "${data.azurerm_public_ip.quickVM.ip_address}"
}

output "jumpbox_private_ip" {
  description = "private IP address of the quickVM server"
  value       = "${azurerm_network_interface.quickVM.private_ip_address}"
}
