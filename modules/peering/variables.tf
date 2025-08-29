variable "environment" {}
variable "location_short" {}
variable "hub_rg_name" {}
variable "hub_vnet_name" {}
variable "spoke_vnet_id" {}
variable "spoke_rg_name" {}
variable "spoke_vnet_name" {}
variable "hub_vnet_id" {}
variable "resource_tags" {
  type    = map(string)
  default = {}
}
