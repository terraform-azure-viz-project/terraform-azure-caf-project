variable "environment" {}
variable "location_short" {}
variable "location" {}
variable "tenant_id" {}
variable "management_sub_id" {}
variable "connectivity_sub_id" {}
variable "sandbox_sub_ids" {
  type = list(string)
  default = []
}
variable "principal_id" {}
variable "app_name" {
  type    = string
  default = "caf"
}
variable "role_definition_name" {
  type    = string
  default = "Contributor"
}
variable "hub_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}
variable "hub_gateway_subnet_prefix" {
  type    = list(string)
  default = ["10.0.1.0/24"]
}
variable "virtual_hub_id" {
  type    = string
  default = ""
}
variable "resource_tags" {
  type    = map(string)
  default = {}
}
