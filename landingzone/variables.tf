variable "location_short" {}
variable "environment" {}
variable "location" {}
variable "tenant_id" {}
variable "vpn_gateway_sku" {}
variable "management_sub_id" {}
#variable "management_group_id" {}
#sandbox_sub_ids = ["/subscriptions/724ad382-04db-437f-a107-b8c39158cf99"]
variable "sandbox_sub_ids" {} 
variable "connectivity_sub_id" {}
variable "policy_assignment_scope" {}
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
variable "subnet_id" {
  type    = string
  default = ""
}
variable "resource_tags" {
  type    = map(string)
  default = {}
}
variable "client_address_pool" {
  type    = list(string)
  default = ["172.168.3.0/24"]
}
