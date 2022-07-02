terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}


module "resource_group" {
  source  = "./module/rg"
  environment_name  = var.environment_name
  location          = var.location
  rg_name           = var.resource_group_name
}

module "key-vault" {
  source  = "./module/kv"
  environment_name  = var.environment_name
  location          = var.location
  rg_name           = var.resource_group_name
  name              = "${var.environment_name}-${var.kv}"
}

module "aad_sp" {
  source  = "./module/aad"
  application_name = "${var.environment_name}-${var.application_name}"
}

resource "azurerm_key_vault_secret" "sp_secret" {
  name         = "broker-consumer-sp-creds"
  value        = module.aad_sp.sp_password
  key_vault_id = module.key-vault.kv_id
  expiration_date = module.aad_sp.sp_end_date
}

resource "azurerm_key_vault_secret" "sp_secret-2" {
  name         = "broker-consumer-sp-creds-2"
  value        = "test"
  key_vault_id = module.key-vault.kv_id
  expiration_date = null
}

resource "azurerm_key_vault_secret" "client_secret" {
  name         = "broker-consumer-app-creds"
  value        = module.aad_sp.app_password
  key_vault_id = module.key-vault.kv_id
  expiration_date = module.aad_sp.app_end_date
}