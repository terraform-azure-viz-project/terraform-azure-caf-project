variable "environment" {}
variable "location_short" {}
variable "location" {}
variable "rg_name" {}
variable "subnet_id" {}
variable "ssh_public_key" {}
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
