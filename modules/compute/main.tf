data "azurerm_resources" "existing_vms" {
  type                = "Microsoft.Compute/virtualMachines"
  resource_group_name = var.rg_name
  required_tags       = var.resource_tags
}

data "azurerm_resources" "existing_nics" {
  type                = "Microsoft.Network/networkInterfaces"
  resource_group_name = var.rg_name
  required_tags       = var.resource_tags
}

locals {
  vm_prefix  = "vm"
  nic_prefix = "nic"
  app        = "linux"
  env        = var.environment
  loc        = var.location_short
  existing_vm_names = [for res in data.azurerm_resources.existing_vms.resources : res.name if can(regex("^${local.vm_prefix}-${local.app}-${local.env}-${local.loc}-\\d{3}$", res.name))]
  vm_counts  = [for name in local.existing_vm_names : tonumber(substr(name, -3, 3))]
  vm_max     = length(local.vm_counts) > 0 ? max(local.vm_counts...) : 0
  vm_instance = format("%03d", local.vm_max + 1)
  vm_name    = "${local.vm_prefix}-${local.app}-${local.env}-${local.loc}-${local.vm_instance}"
  existing_nic_names = [for res in data.azurerm_resources.existing_nics.resources : res.name if can(regex("^${local.nic_prefix}-${local.app}-${local.env}-${local.loc}-\\d{3}$", res.name))]
  nic_counts = [for name in local.existing_nic_names : tonumber(substr(name, -3, 3))]
  nic_max    = length(local.nic_counts) > 0 ? max(local.nic_counts...) : 0
  nic_instance = format("%03d", local.nic_max + 1)
  nic_name   = "${local.nic_prefix}-${local.app}-${local.env}-${local.loc}-${local.nic_instance}"
}

resource "azurerm_network_interface" "nic" {
  count               = var.deploy_vm ? 1 : 0
  name                = local.nic_name
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.resource_tags
  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.deploy_vm ? 1 : 0
  name                = local.vm_name
  resource_group_name = var.rg_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [azurerm_network_interface.nic[0].id]
  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
  }
  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
  tags = var.resource_tags
}
