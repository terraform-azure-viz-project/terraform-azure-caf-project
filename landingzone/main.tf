data "azurerm_management_group" "root" {
  name = var.tenant_id
}

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


# Policy Module: Common Policies (Root Management Group)
module "common_policy" {
  source                 = "../modules/policies"
  environment            = var.environment
  location_short         = var.location_short
 #management_group_id = "/providers/Microsoft.Management/managementGroups/ad7bddb7-da01-42b3-8887-6befb30135bd"  
  policy_json_path       = "../modules/policies/json_policies"
  policy_type            = "common"
  initiative_name        = "common-hipaa-compliance-initiative"
  initiative_display_name = "Common HIPAA Compliance Initiative"
  initiative_description  = "Bundles common policies for HIPAA compliance across all subscriptions"
  tenant_id              =  var.tenant_id
  scope                  = var.policy_assignment_scope
  management_group_id    = data.azurerm_management_group.root.id
  #subscription_id        = var.subscription_id
  assignment_description = "Assigns common HIPAA compliance initiative to the root management group"
  initiative_parameters  = {} # Update with parameters if needed

  #depends_on = [module.vgw, module.management_groups]
}



#module "rbac" {
#  source               = "../modules/rbac"
#  scope                = module.management_groups.platform_id
#  role_definition_name = var.role_definition_name
#  principal_id         = var.principal_id
#}

module "networking_hub" {
  source               = "../modules/networking/hub"
  environment          = var.environment
  location_short       = var.location_short
  location             = var.location
  address_space        = var.hub_address_space
  gateway_subnet_prefix = var.hub_gateway_subnet_prefix
  resource_tags        = var.resource_tags
}

#module "vgw" {
#  source         = "../modules/vgw"
#  environment    = var.environment
#  location_short = var.location_short
#  location       = var.location
#  rg_name        = module.networking_hub.rg_name
#  subnet_id      = module.networking_hub.gateway_subnet_id
#  client_address_pool  = var.client_address_pool
#  vpn_gateway_sku      = var.vpn_gateway_sku
#  tenant_id           = var.tenant_id  
#  resource_tags  = var.resource_tags
#}
