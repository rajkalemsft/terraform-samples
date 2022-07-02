variable "environment_name" {}
variable "location" {}
variable "rg_name" {}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
  tags = {
    Environment = "Terraform Getting Started"
    Team = "CSE-Kraken"
  }
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "${azurerm_resource_group.rg.name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

output "resource_group_id" {
  value = azurerm_resource_group.rg.id
}