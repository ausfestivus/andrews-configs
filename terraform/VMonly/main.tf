# -----------------------------------------------------------------------------
# resourceGroup configuration
# -----------------------------------------------------------------------------
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group}-rg"
  location = "${var.location}"
  tags     = "${var.tags}"
}

# -----------------------------------------------------------------------------
# vnet configuration import.
# we use the remote state of the quickVnet config to get our values
# see https://stackoverflow.com/questions/48650260/layered-deployments-with-terraform
# and https://blog.gruntwork.io/how-to-manage-terraform-state-28f5697e68fa
# -----------------------------------------------------------------------------
data "terraform_remote_state" "quickVnet" {
  backend = "azurerm"
  config {
    resource_group_name  = "terraformstate-rg"
    storage_account_name = "terraformstatesg"
    container_name       = "tfstate"
    key                  = "abconf.terraform.quickVnetState"
  }
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
  destination_address_prefixes  = ["${data.terraform_remote_state.quickVnet.subnet_prefix}"]
  destination_port_range      = "22"
  protocol                    = "TCP"
}

resource "azurerm_network_security_rule" "www_access" {
  name                        = "www-access-rule"
  network_security_group_name = "${azurerm_network_security_group.nsg.name}"
  resource_group_name         = "${azurerm_resource_group.rg.name}"
  direction                   = "Inbound"
  access                      = "Allow"
  priority                    = 210
  source_address_prefix       = "*"
  source_port_range           = "*"
  destination_address_prefixes  = ["${data.terraform_remote_state.quickVnet.subnet_prefix}"]
  destination_port_ranges      = ["80", "443"]
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
    subnet_id                     = "${data.terraform_remote_state.quickVnet.subnet_id}"
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

resource "azurerm_managed_disk" "datadisk" {
  name                 = "${var.hostname}-datadisk"
  location             = "${var.location}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "10"
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
    disk_size_gb      = "10"
    create_option     = "Attach"
    lun               = 0
  }

  os_profile {
    computer_name  = "${var.hostname}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.ubuntu_user_secret}"
    custom_data    =  "${file("init.conf")}"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/ubuntu/.ssh/authorized_keys"
      key_data = "${var.ssh_key_public}"
    }
  }

  connection {
    type     = "ssh"
    host        = "${azurerm_public_ip.pip.fqdn}"
    user        = "ubuntu"
    # By default, terraform will use a running ssh-agent on a *nix host.
    # on windows it uses pagent.
    #agent       = false
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "/usr/bin/sudo DEBIAN_FRONTEND=noninteractive /usr/bin/apt-get -y update",
  #     "/usr/bin/sudo DEBIAN_FRONTEND=noninteractive /usr/bin/apt-get -y install pwgen htop sysstat dstat iotop vim molly-guard unattended-upgrades screen git",
  #     "/usr/bin/sudo DEBIAN_FRONTEND=noninteractive /usr/bin/apt-get -y dist-upgrade",
  #     "/usr/bin/sudo DEBIAN_FRONTEND=noninteractive /usr/bin/apt-get -y auto-remove",
  #   ]
  # }
}

# -----------------------------------------------------------------------------
# Linux vm DNS configuration
# -----------------------------------------------------------------------------
resource "azurerm_dns_cname_record" "vmonly" {
  name                = "vmonly"
  zone_name           = "${var.parent_zone}"
  resource_group_name = "rgDNSZones"
  ttl                 = 300
  record              = "${azurerm_public_ip.pip.fqdn}"
}

# -----------------------------------------------------------------------------
# Data items.
# -----------------------------------------------------------------------------
data "azurerm_public_ip" "pip" {
  name                = "${azurerm_public_ip.pip.name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  depends_on          = ["azurerm_virtual_machine.vm"]
}
