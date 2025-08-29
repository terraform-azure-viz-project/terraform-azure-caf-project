variable "environment" {}
variable "location_short" {}
variable "location" {}
variable "address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}
variable "gateway_subnet_prefix" {
  type    = list(string)
  default = ["10.0.1.0/24"]
}
variable "rg_name" {}
variable "resource_tags" {
  type    = map(string)
  default = {}
}
