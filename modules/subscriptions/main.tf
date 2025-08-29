resource "azurerm_management_group_subscription_association" "management" {
  management_group_id = var.management_mg_id
  subscription_id     = var.management_sub_id
}

resource "azurerm_management_group_subscription_association" "connectivity" {
  management_group_id = var.connectivity_mg_id
  subscription_id     = var.connectivity_sub_id
}

resource "azurerm_management_group_subscription_association" "sandbox" {
  for_each            = toset(var.sandbox_sub_ids)
  management_group_id = var.sandbox_mg_id
  subscription_id     = each.value
}
