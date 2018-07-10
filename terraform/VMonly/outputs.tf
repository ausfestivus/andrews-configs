output "hostname" {
  value = "${var.hostname}"
}

output "vm_csp_pip" {
  value = "${data.azurerm_public_ip.pip.ip_address}"
}

output "vm_csp_fqdn" {
  value = "${azurerm_public_ip.pip.fqdn}"
}

output "vm_private_fqdn" {
  value = "${azurerm_dns_cname_record.vmonly.name}.${azurerm_dns_cname_record.vmonly.zone_name}"
}

output "ssh_command" {
  value = "ssh -i ~/.ssh/azure-ubuntu-default ${var.admin_username}@${azurerm_dns_cname_record.vmonly.name}.${azurerm_dns_cname_record.vmonly.zone_name}"
}
