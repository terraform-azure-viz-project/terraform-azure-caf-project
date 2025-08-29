output "vnet_id" {
  value = azurerm_virtual_network.spoke.id
}

output "vnet_name" {
  value = azurerm_virtual_network.spoke.name
}

output "rg_name" {
  value = azurerm_resource_group.spoke.name
}

output "vm_subnet_id" {
  value = azurerm_subnet.vm.id
}

output "additional_subnet_ids" {
  value = { for k, v in azurerm_subnet.additional : k => v.id }
}
