locals {
  rg_prefix   = "rg"
  vnet_prefix = "vnet"
  snet_prefix = "snet"
  app         = "hub"
  env         = var.environment
  loc         = var.location_short
  vnet_instance = "001"
  vnet_name   = "${local.vnet_prefix}-${local.app}-${local.env}-${local.loc}-${local.vnet_instance}"
  rg_name     = "${local.rg_prefix}-${local.app}-${local.env}-${local.loc}-${local.vnet_instance}"
  gateway_app = "gateway"
  gateway_instance = "001"
  gateway_name = "${local.snet_prefix}-${local.gateway_app}-${local.env}-${local.loc}-${local.gateway_instance}"
}

resource "azurerm_resource_group" "hub" {
  name     = local.rg_name
  location = var.location
  tags     = var.resource_tags
}

resource "azurerm_virtual_network" "hub" {
  name                = local.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.hub.name
  tags                = var.resource_tags
}

resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = var.gateway_subnet_prefix
}

# Optional: Query existing resources only after the resource group is created
data "azurerm_resources" "existing_vnets" {
  type                = "Microsoft.Network/virtualNetworks"
  resource_group_name = azurerm_resource_group.hub.name
  required_tags       = var.resource_tags
  depends_on          = [azurerm_resource_group.hub]
}

data "azurerm_resources" "existing_subnets" {
  type                = "Microsoft.Network/virtualNetworks/subnets"
  resource_group_name = azurerm_resource_group.hub.name
  required_tags       = var.resource_tags
  depends_on          = [azurerm_resource_group.hub]
}

locals {
  existing_vnet_names = [for res in try(data.azurerm_resources.existing_vnets.resources, []) : res.name if can(regex("^${local.vnet_prefix}-${local.app}-${local.env}-${local.loc}-\\d{3}$", res.name))]
  vnet_counts = [for name in local.existing_vnet_names : tonumber(substr(name, -3, 3))]
  vnet_max    = length(local.vnet_counts) > 0 ? max(local.vnet_counts...) : 0
  existing_gateway_names = [for res in try(data.azurerm_resources.existing_subnets.resources, []) : res.name if can(regex("^${local.snet_prefix}-${local.gateway_app}-${local.env}-${local.loc}-\\d{3}$", res.name))]
  gateway_counts = [for name in local.existing_gateway_names : tonumber(substr(name, -3, 3))]
  gateway_max = length(local.gateway_counts) > 0 ? max(local.gateway_counts...) : 0
}
