data "azurerm_resources" "existing_peerings" {
  type                = "Microsoft.Network/virtualNetworkPeerings"
  resource_group_name = var.hub_rg_name
  required_tags       = var.resource_tags
}

locals {
  prefix = "peer"
  app    = "hubspoke"
  env    = var.environment
  loc    = var.location_short
  instance = "001"
  hub_to_spoke_name = "${local.prefix}-${local.app}-hubtospoke-${local.env}-${local.loc}-${local.instance}"
  spoke_to_hub_name = "${local.prefix}-${local.app}-spoketohub-${local.env}-${local.loc}-${local.instance}"
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = local.hub_to_spoke_name
  resource_group_name       = var.hub_rg_name
  virtual_network_name      = var.hub_vnet_name
  remote_virtual_network_id = var.spoke_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = local.spoke_to_hub_name
  resource_group_name       = var.spoke_rg_name
  virtual_network_name      = var.spoke_vnet_name
  remote_virtual_network_id = var.hub_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic   = true
}
