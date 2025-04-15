terraform {
  backend "azurerm" {
    resource_group_name  = "devops-rg"
    storage_account_name = "tfstate16669"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}