module "networking_spoke" {
  source            = "../../../modules/networking/spoke"
  environment       = var.environment
  location_short    = var.location_short
  location          = var.location
  address_space     = var.spoke_address_space
  vm_subnet_prefix  = var.spoke_vm_subnet_prefix
  resource_tags     = var.resource_tags
  additional_subnets = var.additional_subnets
}

module "peering" {
  source            = "../../../modules/peering"
  environment       = var.environment
  location_short    = var.location_short
  hub_rg_name       = var.hub_rg_name
  hub_vnet_name     = var.hub_vnet_name
  hub_vnet_id       = var.hub_vnet_id
  spoke_rg_name     = module.networking_spoke.rg_name
  spoke_vnet_name   = module.networking_spoke.vnet_name
  spoke_vnet_id     = module.networking_spoke.vnet_id
  resource_tags     = var.resource_tags
}

module "compute" {
  source            = "../../../modules/compute"
  environment       = var.environment
  location_short    = var.location_short
  location          = var.location
  rg_name           = module.networking_spoke.rg_name
  subnet_id         = module.networking_spoke.vm_subnet_id
  ssh_public_key    = var.ssh_public_key
  deploy_vm         = var.deploy_vm
  vm_size           = var.vm_size
  admin_username    = var.admin_username
  os_disk_type      = var.os_disk_type
  image_publisher   = var.image_publisher
  image_offer       = var.image_offer
  image_sku         = var.image_sku
  image_version     = var.image_version
  resource_tags     = var.resource_tags
}
