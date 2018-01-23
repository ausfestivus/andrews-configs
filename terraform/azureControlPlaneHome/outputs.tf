output "jumpbox_public_ip" {
  description = "public IP address of the jumpbox server"
  value       = "${azurerm_public_ip.jumpbox.ip_address}"
}

output "jumpbox_private_ip" {
  description = "private IP address of the jumpbox server"
  value       = "${azurerm_network_interface.jumpbox.private_ip_address}"
}