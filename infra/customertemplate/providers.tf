terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias = "prod"
  subscription_id = ""
  features {}
}

provider "azurerm" {
  alias = "dev"
  subscription_id = ""
  features {}
}

provider "azurerm" {
  alias = "management"
  subscription_id = ""
  features {}
}

provider "azurerm" {
  alias = "connectivity"
  subscription_id = ""
  features {}
}
