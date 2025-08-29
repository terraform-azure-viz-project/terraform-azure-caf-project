module "management_groups" {
  source         = "../modules/management_groups"
  environment    = var.environment
  location_short = var.location_short
  tenant_id      = var.tenant_id
  app_name       = var.app_name
}

module "subscriptions" {
  source               = "../modules/subscriptions"
  management_mg_id     = module.management_groups.management_id
  management_sub_id    = var.management_sub_id
  connectivity_mg_id   = module.management_groups.connectivity_id
  connectivity_sub_id  = var.connectivity_sub_id
  sandbox_mg_id        = module.management_groups.sandbox_id
  sandbox_sub_ids      = var.sandbox_sub_ids
}

module "policies" {
  source         = "../modules/policies"
  environment    = var.environment
  location_short = var.location_short
  platform_mg_id = module.management_groups.platform_id
  sandbox_mg_id  = module.management_groups.sandbox_id
}

module "rbac" {
  source               = "../modules/rbac"
  scope                = module.management_groups.platform_id
  role_definition_name = var.role_definition_name
  principal_id         = var.principal_id
}

module "networking_hub" {
  source               = "../modules/networking/hub"
  environment          = var.environment
  location_short       = var.location_short
  location             = var.location
  address_space        = var.hub_address_space
  gateway_subnet_prefix = var.hub_gateway_subnet_prefix
  rg_name              = "rg-hub-${var.environment}-${var.location_short}-001"
  resource_tags        = var.resource_tags
}

module "vgw" {
  source         = "../modules/vgw"
  environment    = var.environment
  location_short = var.location_short
  location       = var.location
  rg_name        = module.networking_hub.rg_name
  virtual_hub_id = var.virtual_hub_id
  resource_tags  = var.resource_tags
}
