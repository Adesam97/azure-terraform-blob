resource "azurerm_storage_account" "stage" {
  name                     = "stageappstorageacct"
  resource_group_name      = azurerm_resource_group.stage.name
  location                 = azurerm_resource_group.stage.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

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

output "stage_website_url" {
  value = azurerm_storage_account.stage.primary_web_endpoint
}