resource "azurerm_container_registry" "main" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                           = var.sku
  admin_enabled                 = var.admin_enabled
  public_network_access_enabled = var.public_network_access_enabled
  network_rule_bypass_option    = var.network_rule_bypass_option
  anonymous_pull_enabled        = var.anonymous_pull_enabled
  data_endpoint_enabled         = var.sku == "Premium" ? var.data_endpoint_enabled : false
  quarantine_policy_enabled     = var.sku == "Premium" ? var.quarantine_policy_enabled : false
  retention_policy_in_days      = var.sku == "Premium" ? var.retention_policy_in_days : null
  zone_redundancy_enabled       = var.sku == "Premium" ? var.zone_redundancy_enabled : false

  tags = var.tags
}

# RBAC: Grant managed identity AcrPush role (push and pull images)
# Automatically created when managed_identity_id is provided - zero config
resource "azurerm_role_assignment" "managed_identity_acr_push" {
  count                = var.enable_managed_identity ? 1 : 0
  name                 = uuidv5("dns", "${azurerm_container_registry.main.id}-${var.managed_identity_id}-acr-push")
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPush"
  principal_id         = var.managed_identity_id
}

# RBAC: Grant managed identity AcrPull role (pull images - for Container Apps workloads)
# Automatically created when managed_identity_id is provided - zero config
resource "azurerm_role_assignment" "managed_identity_acr_pull" {
  count                = var.enable_managed_identity ? 1 : 0
  name                 = uuidv5("dns", "${azurerm_container_registry.main.id}-${var.managed_identity_id}-acr-pull")
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = var.managed_identity_id
}

# Diagnostic settings
resource "azurerm_monitor_diagnostic_setting" "main" {
  count                      = var.enable_observability ? 1 : 0
  name                       = "diag-${var.name}"
  target_resource_id         = azurerm_container_registry.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "ContainerRegistryRepositoryEvents"
  }

  enabled_log {
    category = "ContainerRegistryLoginEvents"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
