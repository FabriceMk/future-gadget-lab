# Default Azure Region
variable "region" {
  type = "string"
}

# Resource Group for shared Components
variable "shared-components-resource-group" {
  type = "string"
}

# Shared App Service Plan Id
variable "shared-app-service-plan-id" {
  type = "string"
}
