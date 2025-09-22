terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.3"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.6.0"
    }
  }

  cloud { 
    organization = "AE_NV" 

    workspaces { 
      name = "Elias_Dams_dev" 
    } 
  }

  required_version = ">= 1.5.7"
}

# Configure the Azure provider
provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}
