terraform {
  backend "azurerm" {
    resource_group_name  = ""
    storage_account_name = ""
    container_name       = ""
    key                  = "customer.tfstate"
    subscription_id      = ""
    tenant_id            = ""
  }
}
