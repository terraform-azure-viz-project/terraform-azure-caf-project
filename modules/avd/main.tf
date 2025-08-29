data "azurerm_resources" "existing_hostpools" {
  type                = "Microsoft.DesktopVirtualization/hostPools"
  resource_group_name = "rg-avd-${var.environment}-${var.location_short}-001"
  required_tags       = var.resource_tags
}

locals {
  prefix = "avd"
  app    = "hostpool"
  env    = var.environment
  loc    = var.location_short
  existing_names = [for res in data.azurerm_resources.existing_hostpools.resources : res.name if can(regex("^${local.prefix}-${local.app}-${local.env}-${local.loc}-\\d{3}$", res.name))]
  counts = [for name in local.existing_names : tonumber(substr(name, -3, 3))]
  max    = length(local.counts) > 0 ? max(local.counts...) : 0
  instance = format("%03d", local.max + 1)
  name   = "${local.prefix}-${local.app}-${local.env}-${local.loc}-${local.instance}"
}

resource "azurerm_resource_group" "avd" {
  name     = "rg-avd-${var.environment}-${var.location_short}-001"
  location = var.location
  tags     = var.resource_tags
}

resource "azurerm_virtual_desktop_host_pool" "hostpool" {
  name                = local.name
  location            = var.location
  resource_group_name = azurerm_resource_group.avd.name
  type                = "Pooled"
  load_balancer_type  = "BreadthFirst"
  tags                = var.resource_tags
}
