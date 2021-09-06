provider "azurerm" {
  features {}
}

# Use an Azure storage account to store/retrieve the Terraform state
terraform {
  backend "azurerm" {
    resource_group_name  = "shared-components-rg"
    storage_account_name = "fabricemkshared"
    container_name       = "terraform"
    key                  = "future-gadget-lab.terraform.tfstate"
  }
}

# Object to get several information about the current User/Service Principal executing the Terraform plan
data "azurerm_client_config" "current" {}

# Create a resource group dedicated to the project
resource "azurerm_resource_group" "future-gadget-lab-rg" {
  name     = "future-gadget-lab-rg"
  location = var.region
}

resource "azurerm_storage_account" "futuregadgetlab-storage" {
  name                     = "futuregadgetlab"
  resource_group_name      = azurerm_resource_group.future-gadget-lab-rg.name
  location                 = azurerm_resource_group.future-gadget-lab-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Log Analytics is needed for the new Workpspace mode of AppInsights
  resource "azurerm_log_analytics_workspace" "future-gadget-lab-log" {
  name                = "future-gadget-lab-log"
  location            = azurerm_resource_group.future-gadget-lab-rg.location
  resource_group_name = azurerm_resource_group.future-gadget-lab-rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "future-gadget-lab-ai" {
  name                = "future-gadget-lab-ai"
  location            = azurerm_resource_group.future-gadget-lab-rg.location
  resource_group_name = azurerm_resource_group.future-gadget-lab-rg.name
  workspace_id        = azurerm_log_analytics_workspace.future-gadget-lab-log.id
  application_type    = "web"
}

resource "azurerm_key_vault" "future-gadget-lab-kv" {
  name                        = "future-gadget-lab-kv"
  location                    = azurerm_resource_group.future-gadget-lab-rg.location
  resource_group_name         = azurerm_resource_group.future-gadget-lab-rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
}

# Create an Access Policy for current deployment Service Principal to setup some secrets in KeyVault
resource "azurerm_key_vault_access_policy" "deployment-keyvault-access-policy" {
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id
  key_vault_id = azurerm_key_vault.future-gadget-lab-kv.id

  secret_permissions = [
    "List", "Get", "Set", "Delete", "Backup", "Purge", "Recover", "Restore"
  ]
}

# Create an Access Policy for the WebApp in order to retrieve secrets
resource "azurerm_key_vault_access_policy" "webapp-keyvault-access-policy" {
  tenant_id    = azurerm_app_service.future-gadget-lab-wa.identity.0.tenant_id
  object_id    = azurerm_app_service.future-gadget-lab-wa.identity.0.principal_id
  key_vault_id = azurerm_key_vault.future-gadget-lab-kv.id

  secret_permissions = [
    "Get",
  ]
}

# Put the Storage Connection String to KeyVault
resource "azurerm_key_vault_secret" "storage-connectionstring" {
  name         = "futuregadgetlab-storage-connectionstring"
  value        = azurerm_storage_account.futuregadgetlab-storage.primary_connection_string
  key_vault_id = azurerm_key_vault.future-gadget-lab-kv.id
}

resource "azurerm_app_service" "future-gadget-lab-wa" {
  name                = "future-gadget-lab-wa"
  location            = azurerm_resource_group.future-gadget-lab-rg.location
  resource_group_name = azurerm_resource_group.future-gadget-lab-rg.name
  app_service_plan_id = var.shared-app-service-plan-id

  client_affinity_enabled = false
  https_only              = true

  # Use System Managed Identity to authenticate to some Azure Resources like KeyVault
  # Without requiring the app to store credentials.
  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on  = true
    ftps_state = "Disabled"
    health_check_path = "/health"

    cors {
      allowed_origins = ["*"]
    }
  }

  app_settings = {
    # Azure App Insights Integration https://docs.microsoft.com/en-us/azure/azure-monitor/app/azure-web-apps?tabs=netcore
    "APPINSIGHTS_INSTRUMENTATIONKEY"                  = azurerm_application_insights.future-gadget-lab-ai.instrumentation_key,
    "ApplicationInsightsAgent_EXTENSION_VERSION"      = "~2",
    "XDT_MicrosoftApplicationInsights_Mode"           = "recommended",
    "InstrumentationEngine_EXTENSION_VERSION"         = "~1",
    "XDT_MicrosoftApplicationInsights_BaseExtensions" = "~1"

    # Set Azure Storage connection string from KV
    "StorageConnectionString" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.future-gadget-lab-kv.vault_uri}secrets/${azurerm_key_vault_secret.storage-connectionstring.name})"
  }
}

# TODO:: Configure Alerts

