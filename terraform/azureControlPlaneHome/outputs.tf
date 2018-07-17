output "jumpvm_public_ip" {
  description = "public IP address of the jumpvm server"
  value       = "${azurerm_public_ip.jumpvm.ip_address}"
}

output "jumpvm_private_ip" {
  description = "private IP address of the jumpvm server"
  value       = "${azurerm_network_interface.jumpvm.private_ip_address}"
}

output "jumpvm_ssh_command" {
  value      = "ssh ${var.admin_username}@${azurerm_public_ip.jumpvm.fqdn}"
  depends_on = ["azurerm_virtual_machine.jumpvm"]
}
