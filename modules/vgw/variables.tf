variable "environment" {}
variable "location_short" {}
variable "location" {}
variable "rg_name" {}
variable "virtual_hub_id" {}
variable "resource_tags" {
  type    = map(string)
  default = {}
}
