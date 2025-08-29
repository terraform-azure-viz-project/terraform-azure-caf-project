locals {
  rg_prefix   = "rg"
  vnet_prefix = "vnet"
  snet_prefix = "snet"
  app         = "spoke"
  env         = var.environment
  loc         = var.location_short
  vnet_instance = "001"
  vnet_name   = "${local.vnet_prefix}-${local.app}-${local.env}-${local.loc}-${local.vnet_instance}"
  rg_name     = "${local.rg_prefix}-${local.app}-${local.env}-${local.loc}-${local.vnet_instance}"
  vm_app = "vm"
  vm_instance = "001"
  vm_name = "${local.snet_prefix}-${local.vm_app}-${local.env}-${local.loc}-${local.vm_instance}"
}

resource "azurerm_resource_group" "spoke" {
  name     = local.rg_name
  location = var.location
  tags     = var.resource_tags
}

resource "azurerm_virtual_network" "spoke" {
  name                = local.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.spoke.name
  tags                = var.resource_tags
}

resource "azurerm_subnet" "vm" {
  name                 = local.vm_name
  resource_group_name  = azurerm_resource_group.spoke.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = var.vm_subnet_prefix
}

resource "azurerm_subnet" "additional" {
  for_each             = var.additional_subnets
  name                 = "${local.snet_prefix}-${each.key}-${local.env}-${local.loc}-${format("%03d", index(keys(var.additional_subnets), each.key) + 1)}"
  resource_group_name  = azurerm_resource_group.spoke.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = each.value.address_prefixes
}

# Optional: Query existing resources only after the resource group is created
data "azurerm_resources" "existing_vnets" {
  type                = "Microsoft.Network/virtualNetworks"
  resource_group_name = azurerm_resource_group.spoke.name
  required_tags       = var.resource_tags
  depends_on          = [azurerm_resource_group.spoke]
}

data "azurerm_resources" "existing_subnets" {
  type                = "Microsoft.Network/virtualNetworks/subnets"
  resource_group_name = azurerm_resource_group.spoke.name
  required_tags       = var.resource_tags
  depends_on          = [azurerm_resource_group.spoke]
}

locals {
  existing_vnet_names = [for res in try(data.azurerm_resources.existing_vnets.resources, []) : res.name if can(regex("^${local.vnet_prefix}-${local.app}-${local.env}-${local.loc}-\\d{3}$", res.name))]
  vnet_counts = [for name in local.existing_vnet_names : tonumber(substr(name, -3, 3))]
  vnet_max    = length(local.vnet_counts) > 0 ? max(local.vnet_counts...) : 0
  existing_vm_names = [for res in try(data.azurerm_resources.existing_subnets.resources, []) : res.name if can(regex("^${local.snet_prefix}-${local.vm_app}-${local.env}-${local.loc}-\\d{3}$", res.name))]
  vm_counts = [for name in local.existing_vm_names : tonumber(substr(name, -3, 3))]
  vm_max = length(local.vm_counts) > 0 ? max(local.vm_counts...) : 0
}
