# terraform - quickvnet

A terraform config which will build a quick vNet and Subnet in Azure.

```
terraform init
terraform plan
terraform apply
```

```
terraform destroy
```

## Shared State
Note that because this is a shared resource that other Terraform configs will rely on we need to store and share the state.
See https://stackoverflow.com/questions/48650260/layered-deployments-with-terraform

The following values are saved in the remote state:

```
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
```
