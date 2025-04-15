variable "resource_group_name" {
  type    = string
  default = "devops-rg"
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "ssh_public_key_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa_devops.pub"
  description = "Clé publique SSH"
  type        = string
}
