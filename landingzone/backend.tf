terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform"
    storage_account_name = "tfstate87123" 
    container_name       = "tfstate1"
    key                  = "terraform.tfstate"
    subscription_id      = "2845c48d-ce94-43f9-b7c4-67cb1541a1a9"
    tenant_id            = "ad7bddb7-da01-42b3-8887-6befb30135bd"
  }
}
