provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = "=1.36.0"
}

terraform {
  backend "azurerm" {
    resource_group_name  = "shared-components-rg"
    storage_account_name = "fabricemkshared"
    container_name       = "terraform"
    key                  = "future-gadget-lab.terraform.tfstate"
  }
}

# Create a resource group dedicated to the project
resource "azurerm_resource_group" "future-gadget-lab-rg" {
  name     = "future-gadget-lab-rg"
  location = "${var.region}"
}

# TODO: Add Storage

resource "azurerm_application_insights" "future-gadget-lab-ai" {
  name                = "future-gadget-lab-ai"
  location            = "${azurerm_resource_group.future-gadget-lab-rg.location}"
  resource_group_name = "${azurerm_resource_group.future-gadget-lab-rg.name}"
  application_type    = "Web"
}

resource "azurerm_app_service" "future-gadget-lab-wa" {
  name = "future-gadget-lab-wa"
  location            = "${azurerm_resource_group.future-gadget-lab-rg.location}"
  resource_group_name = "${azurerm_resource_group.future-gadget-lab-rg.name}"
  app_service_plan_id = "${var.shared-app-service-plan-id}"

  client_affinity_enabled = false
  https_only = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on = true
    ftps_state = "Disabled"

    cors {
      allowed_origins = ["*"]
    }
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "8.9.4",

    # Azure App Insights Integration https://docs.microsoft.com/en-us/azure/azure-monitor/app/azure-web-apps?tabs=netcore
    "APPINSIGHTS_INSTRUMENTATIONKEY" = "${azurerm_application_insights.future-gadget-lab-ai.instrumentation_key}",
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~2",
    "XDT_MicrosoftApplicationInsights_Mode" = "recommended",
    "InstrumentationEngine_EXTENSION_VERSION" = "~1",
    "XDT_MicrosoftApplicationInsights_BaseExtensions" = "~1"
  }
}

# TODO:: Configure Alerts

# TODO: Add KeyVault
