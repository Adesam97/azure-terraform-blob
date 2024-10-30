resource "azurerm_resource_group" "dev" {
  name     = "dev-rg"
  location = "East US"
}

resource "azurerm_storage_account" "dev" {
  name                     = "devappstorageacct7f69"
  resource_group_name      = azurerm_resource_group.dev.name
  location                 = azurerm_resource_group.dev.location
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
    Environment = "development"
    ManagedBy   = "Terraform"
    Project     = "NPM Application"
  }
}

output "dev_website_url" {
  value = azurerm_storage_account.dev.primary_web_endpoint
}