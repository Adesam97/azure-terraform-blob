variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}

variable "client_id" {
  type        = string
  description = "Azure Service Principal Client ID"
}

variable "client_secret" {
  type        = string
  description = "Azure Service Principal Client Secret"
  sensitive   = true
}

variable "environment" {
  type        = string
  description = "Azure deployment environment"
}

variable "tenant_id" {
  type        = string
  description = "Azure Tenant ID"
}

resource "azurerm_resource_group" "stage" {
  name     = "stage-rg"
  location = "East US"
}
