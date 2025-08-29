data "azurerm_resources" "existing_vgws" {
  type                = "Microsoft.Network/vpnGateways"
  resource_group_name = var.rg_name
  required_tags       = var.resource_tags
}

locals {
  prefix = "vgw"
  app    = "vpn"
  env    = var.environment
  loc    = var.location_short
  existing_names = [for res in data.azurerm_resources.existing_vgws.resources : res.name if can(regex("^${local.prefix}-${local.app}-${local.env}-${local.loc}-\\d{3}$", res.name))]
  counts = [for name in local.existing_names : tonumber(substr(name, -3, 3))]
  max    = length(local.counts) > 0 ? max(local.counts...) : 0
  instance = format("%03d", local.max + 1)
  name   = "${local.prefix}-${local.app}-${local.env}-${local.loc}-${local.instance}"
}

resource "azurerm_vpn_gateway" "vgw" {
  name                = local.name
  location            = var.location
  resource_group_name = var.rg_name
  virtual_hub_id      = var.virtual_hub_id
  tags                = var.resource_tags
}
