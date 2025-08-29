module "avd" {
  source         = "../../../modules/avd"
  environment    = var.environment
  location_short = var.location_short
  location       = var.location
  resource_tags  = var.resource_tags
}
