# azurerm_container_registry

Terraform module for Azure Container Registry (ACR).

## Usage

```hcl
module "container_registry" {
  source = "git::https://github.com/orafaelferreiraa/tfmodules-as-a-service-stack.git//modules/azurerm_container_registry?ref=main"

  name                = "crMyAppEus2a1b2"
  location            = "eastus2"
  resource_group_name = "rg-myapp-eus2"
  sku                 = "Basic"

  # Just provide the managed identity principal_id — RBAC is automatic
  managed_identity_id = "00000000-0000-0000-0000-000000000000"

  enable_observability        = true
  log_analytics_workspace_id  = "/subscriptions/.../providers/Microsoft.OperationalInsights/workspaces/log-myapp"

  tags = {
    managed-by = "terraform"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.9.0 |
| azurerm | ~> 4.57 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Container Registry name (alphanumeric only) | `string` | — | yes |
| location | Azure region | `string` | — | yes |
| resource_group_name | Resource group name | `string` | — | yes |
| sku | SKU: Basic, Standard, Premium | `string` | `"Basic"` | no |
| admin_enabled | Enable admin user | `bool` | `false` | no |
| managed_identity_id | Principal ID — RBAC assigned automatically when provided | `string` | `null` | no |
| public_network_access_enabled | Allow public network access | `bool` | `true` | no |
| network_rule_bypass_option | Trusted Azure services bypass: None, AzureServices | `string` | `"AzureServices"` | no |
| anonymous_pull_enabled | Allow anonymous pull (Standard/Premium only) | `bool` | `false` | no |
| data_endpoint_enabled | Enable dedicated data endpoints (Premium only) | `bool` | `false` | no |
| quarantine_policy_enabled | Enable quarantine policy (Premium only) | `bool` | `false` | no |
| retention_policy_in_days | Days to retain untagged manifests (Premium only) | `number` | `null` | no |
| zone_redundancy_enabled | Enable zone redundancy (Premium only) | `bool` | `false` | no |
| tags | Resource tags | `map(string)` | `{}` | no |
| enable_observability | Enable diagnostic settings | `bool` | `false` | no |
| log_analytics_workspace_id | Log Analytics Workspace ID | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | Container Registry ID |
| name | Container Registry name |
| login_server | Login server URL |

## RBAC Roles

When `managed_identity_id` is provided, the module **automatically** assigns:

- **AcrPush** — push and pull images (CI/CD pipelines)
- **AcrPull** — pull images only (Container Apps workloads)

No additional flags needed. Both roles use deterministic `uuidv5()` names to prevent destroy/recreate cycles.

## Diagnostic Logs

When `enable_observability = true`, the module sends to Log Analytics:

- `ContainerRegistryRepositoryEvents` — push, pull, delete events
- `ContainerRegistryLoginEvents` — authentication events
- `AllMetrics` — performance metrics
