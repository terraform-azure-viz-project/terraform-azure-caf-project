variable "environment" {}
variable "location_short" {}
variable "location" {}
variable "client_address_pool" {}
variable "vpn_gateway_sku" {}
variable "rg_name" {}
variable "tenant_id" {}
variable "subnet_id" {}
variable "resource_tags" {
  type    = map(string)
  default = {}
}
