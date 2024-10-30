resource "azurerm_storage_account" "stage" {
  name                     = "stageappstorageacct"
  resource_group_name      = azurerm_resource_group.stage.name
  location                 = azurerm_resource_group.stage.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }

  blob_properties {
    cors_rule {
      allowed_headers    = ["*"]
      allowed_methods    = ["GET", "HEAD"]
      allowed_origins    = ["*"]
      exposed_headers    = ["*"]
      max_age_in_seconds = 3600
    }
  }

  network_rules {
    default_action = "Allow"
  }

  tags = {
    Environment = "staging"
    ManagedBy   = "Terraform"
    Project     = "NPM Application"
  }
}

resource "azurerm_app_service_plan" "stage" {
  name                = "stage-plan"
  location            = azurerm_resource_group.stage.location
  resource_group_name = azurerm_resource_group.stage.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }

  tags = {
    Environment = "staging"
    ManagedBy   = "Terraform"
    Project     = "NPM Application"
  }
}

resource "azurerm_app_service" "stage" {
  name                = "stage-app-service"
  location            = azurerm_resource_group.stage.location
  resource_group_name = azurerm_resource_group.stage.name
  app_service_plan_id = azurerm_app_service_plan.stage.id

  site_config {
    linux_fx_version = "NODE|18-lts"
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "WEBSITE_NPM_DEFAULT_VERSION"        = "8.5.5"
  }

  tags = {
    Environment = "staging"
    ManagedBy   = "Terraform"
    Project     = "NPM Application"
  }
}

output "stage_website_url" {
  value = azurerm_storage_account.stage.primary_web_endpoint
}

output "stage_app_service_url" {
  value = azurerm_app_service.stage.default_hostname
}