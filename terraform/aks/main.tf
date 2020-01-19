resource "azurerm_resource_group" "example" {
  name     = "example-resources-aks"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "example-aks1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }
  service_principal {
    client_id     = var.aks_service_principal_client_id
    client_secret = var.aks_service_principal_client_secret
  }
  tags = {
    Environment = "development"
  }
  addon_profile {
    kube_dashboard {
      enabled                    = true
    }    
    http_application_routing {
      enabled                    = false
    }
  }
}
variable "aks_service_principal_client_id" {
  
}
variable "aks_service_principal_client_secret" {
  
}
resource "azurerm_container_registry" "acr" {
  name                     = "akskubekubtraining"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  sku                      = "Basic"
  admin_enabled            = false
}
output "client_certificate" {
  value = azurerm_kubernetes_cluster.example.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.example.kube_config_raw
}