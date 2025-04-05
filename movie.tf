provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-react-movieapp"
  location = "East US"
}

resource "azurerm_service_plan" "asp" {
  name                = "asp-react-movieapp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "B1"
  os_type             = "Windows"
}

resource "azurerm_windows_web_app" "webapp" {
  name                = "react-movie-webapp-001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    always_on = true
  }

  https_only = true

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE = "1"
  }
}
