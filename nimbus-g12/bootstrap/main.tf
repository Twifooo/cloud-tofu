terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

variable "subscription_id" {
  type        = string
  description = "ID de l'abonnement Azure"
}

variable "location" {
  type        = string
  description = "Région Azure"
}

variable "binome" {
  type        = string
  description = "Identifiant du binôme"
  default     = "g12"
}

resource "random_string" "sa" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "state" {
  name     = "rg-tfstate-nimbus-${var.binome}"
  location = var.location
  tags     = { projet = "nimbusshop", owner = var.binome, env = "dev" }
}

resource "azurerm_storage_account" "state" {
  name                     = "stnimbus${var.binome}${random_string.sa.result}"
  resource_group_name      = azurerm_resource_group.state.name
  location                 = azurerm_resource_group.state.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = azurerm_resource_group.state.tags
}

resource "azurerm_storage_container" "state" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.state.id
  container_access_type = "private"
}

output "storage_account_name" {
  description = "Nom du compte de stockage du state"
  value       = azurerm_storage_account.state.name
}