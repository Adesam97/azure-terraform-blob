resource "azurerm_resource_group" "prod" {
  name     = "prod-rg"
  location = "East US"
}

resource "azurerm_storage_account" "prod" {
  name                     = "prodappstorageacct"
  resource_group_name      = azurerm_resource_group.prod.name
  location                 = azurerm_resource_group.prod.location
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
    default_action = "allow"
  }

  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
    Project     = "NPM Application"
  }
}

resource "azurerm_cdn_profile" "prod" {
  name                = "prod-cdn-profile"
  location            = azurerm_resource_group.prod.location
  resource_group_name = azurerm_resource_group.prod.name
  sku                 = "Standard_Microsoft"

  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
    Project     = "NPM Application"
  }
}

resource "azurerm_cdn_endpoint" "prod" {
  name                = "prod-cdn-endpoint"
  profile_name        = azurerm_cdn_profile.prod.name
  location            = azurerm_resource_group.prod.location
  resource_group_name = azurerm_resource_group.prod.name

  origin {
    name      = "primary"
    host_name = azurerm_storage_account.prod.primary_web_host
  }

  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
    Project     = "NPM Application"
  }
}

output "prod_website_url" {
  value = azurerm_storage_account.prod.primary_web_endpoint
}

output "prod_cdn_url" {
  value = azurerm_cdn_endpoint.prod.host_name
}