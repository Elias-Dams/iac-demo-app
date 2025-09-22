# Look up the already-created RG (read-only)
resource "azurerm_resource_group" "rg" {
  name = "MyResourceGroup"
  location = var.location
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  lower   = true
  numeric = true
  special = false
}

# --- storage account ---
resource "azurerm_storage_account" "sa" {
  name                     = "st${var.environment}${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  # kind defaults to StorageV2 in current provider versions
  tags = var.tags
}

# --- blob container ---
resource "azurerm_storage_container" "container" {
  name                  = "blobcontainer"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "blob" # use "private" if your tenant forbids public blob access
}

# Build the public URL to the blob (works if your container_access_type = "blob")
# Example: https://<account>.blob.core.windows.net/<container>/<blob>
locals {
  package_url = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.container.name}/${var.mailfunction_blob_name}"
}

# --- App Service Plan: Windows, Consumption (Y1) ---
resource "azurerm_service_plan" "plan" {
  name                = "asp-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Windows"
  sku_name            = "Y1"
  tags                = var.tags
}

resource "azurerm_windows_function_app" "app" {
  name                = "fn-${var.environment}-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.plan.id

  # The Functions host needs a storage account
  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key

  functions_extension_version = "~4"

  site_config {}

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "custom"          # custom runtime = true
    WEBSITE_RUN_FROM_PACKAGE = local.package_url # URL to your .zip in Blob Storage
  }

  identity { type = "SystemAssigned" }
}
