variable "environment" {}
variable "location_short" {}
variable "location" {}
variable "hub_rg_name" {}
variable "hub_vnet_name" {}
variable "hub_vnet_id" {}
variable "ssh_public_key" {}
variable "spoke_address_space" {
  type    = list(string)
  default = ["10.1.0.0/16"]
}
variable "spoke_vm_subnet_prefix" {
  type    = list(string)
  default = ["10.1.1.0/24"]
}
variable "deploy_vm" {
  type    = bool
  default = true
}
variable "vm_size" {
  type    = string
  default = "Standard_DS1_v2"
}
variable "admin_username" {
  type    = string
  default = "adminuser"
}
variable "os_disk_type" {
  type    = string
  default = "Premium_LRS"
}
variable "image_publisher" {
  type    = string
  default = "Canonical"
}
variable "image_offer" {
  type    = string
  default = "UbuntuServer"
}
variable "image_sku" {
  type    = string
  default = "18.04-LTS"
}
variable "image_version" {
  type    = string
  default = "latest"
}
variable "resource_tags" {
  type    = map(string)
  default = {}
}
variable "additional_subnets" {
  type    = map(object({
    address_prefixes = list(string)
  }))
  default = {}
}
