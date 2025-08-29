data "azurerm_management_group" "root" {
  name = var.tenant_id
}

locals {
  prefix = "vgw"
  app = "vpn"
  env = var.environment
  loc = var.location_short
  instance = "001"
  name = "${local.prefix}-${local.app}-${local.env}-${local.loc}-${local.instance}"
  skip_vgw_check = true  # Set to true for new VNG deployment
}

data "azurerm_resources" "existing_vgws" {
  count               = local.skip_vgw_check ? 0 : 1
  type                = "Microsoft.Network/virtualNetworkGateways"
  resource_group_name = var.rg_name
  required_tags       = var.resource_tags
  # Remove depends_on, as var.rg_name creates implicit dependency
}

resource "azurerm_public_ip" "vgw_pip" {
  name                = "${local.name}-pip"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.resource_tags
  # Remove depends_on, as var.rg_name creates implicit dependency
}

resource "azurerm_virtual_network_gateway" "vgw" {
  name                = local.name
  location            = var.location
  resource_group_name = var.rg_name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  sku                 = "VpnGw1"
  tags                = var.resource_tags
  ip_configuration {
    public_ip_address_id          = azurerm_public_ip.vgw_pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_id
  }

vpn_client_configuration {
    address_space        = var.client_address_pool
    vpn_client_protocols = ["OpenVPN"]
    vpn_auth_types       = ["AAD"]
    aad_tenant           = "https://login.microsoftonline.com/${var.tenant_id}/"
    aad_audience         = "c632b3df-fb67-4d84-bdcf-b95ad541b5c8" # Microsoft-registered App ID
    aad_issuer           = "https://sts.windows.net/${var.tenant_id}/"
  }  

  depends_on = [azurerm_public_ip.vgw_pip]  # Only depend on vgw_pip

}

locals {
  existing_names = [for res in try(data.azurerm_resources.existing_vgws[0].resources, []) : res.name if can(regex("^${local.prefix}-${local.app}-${local.env}-${local.loc}-\\d{3}$", res.name))]
  counts = [for name in local.existing_names : tonumber(substr(name, -3, 3))]
  max = length(local.counts) > 0 ? max(local.counts...) : 0
}
