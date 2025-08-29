output "vnet_id" {
  value = azurerm_virtual_network.hub.id
}

output "vnet_name" {
  value = azurerm_virtual_network.hub.name
}

output "rg_name" {
  value = azurerm_resource_group.hub.name
}

output "gateway_subnet_id" {
  value = azurerm_subnet.gateway.id
}
