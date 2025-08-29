data "azurerm_management_group" "root" {
  name = var.tenant_id
}

locals {
  mg_prefix = "mg"
  app       = var.app_name
  env       = var.environment
  loc       = var.location_short
  instance_count = "001"
  platform_name  = "${local.mg_prefix}-${local.app}-${local.env}-${local.loc}-platform-${local.instance_count}"
  management_name = "${local.mg_prefix}-${local.app}-${local.env}-${local.loc}-management-${local.instance_count}"
  connectivity_name = "${local.mg_prefix}-${local.app}-${local.env}-${local.loc}-connectivity-${local.instance_count}"
  sandbox_name = "${local.mg_prefix}-${local.app}-${local.env}-${local.loc}-sandbox-${local.instance_count}"
}

resource "azurerm_management_group" "platform" {
  display_name               = "Platform"
  name                       = local.platform_name
  parent_management_group_id = data.azurerm_management_group.root.id
}

resource "azurerm_management_group" "management" {
  display_name               = "Management"
  name                       = local.management_name
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "connectivity" {
  display_name               = "Connectivity"
  name                       = local.connectivity_name
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "sandbox" {
  display_name               = "Sandbox"
  name                       = local.sandbox_name
  parent_management_group_id = azurerm_management_group.platform.id
}
