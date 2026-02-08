variable "name" {
  description = "Name of the Container Registry (alphanumeric only, from naming module)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "sku" {
  description = "SKU of the Container Registry. Possible values: Basic, Standard, Premium"
  type        = string
  default     = "Basic"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "SKU must be Basic, Standard, or Premium."
  }
}

variable "admin_enabled" {
  description = "Whether the admin user is enabled"
  type        = bool
  default     = false
}

variable "enable_managed_identity" {
  description = "Enable RBAC role assignments for managed identity"
  type        = bool
  default     = false
}

variable "managed_identity_id" {
  description = "Principal ID of the managed identity. When provided, AcrPush and AcrPull RBAC roles are assigned automatically"
  type        = string
  default     = null
}

variable "public_network_access_enabled" {
  description = "Whether public network access is allowed for the container registry"
  type        = bool
  default     = true
}

variable "network_rule_bypass_option" {
  description = "Whether to allow trusted Azure services to access a network-restricted Container Registry. Possible values: None, AzureServices"
  type        = string
  default     = "AzureServices"

  validation {
    condition     = contains(["None", "AzureServices"], var.network_rule_bypass_option)
    error_message = "Must be None or AzureServices."
  }
}

variable "tags" {
  description = "Tags to apply to the Container Registry"
  type        = map(string)
  default     = {}
}

variable "enable_observability" {
  description = "Enable diagnostic settings"
  type        = bool
  default     = false
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID for diagnostics"
  type        = string
  default     = null
}

variable "anonymous_pull_enabled" {
  description = "Whether to allow anonymous (unauthenticated) pull access. Only supported on Standard or Premium SKU"
  type        = bool
  default     = false
}

variable "data_endpoint_enabled" {
  description = "Whether to enable dedicated data endpoints. Only supported on Premium SKU"
  type        = bool
  default     = false
}

variable "quarantine_policy_enabled" {
  description = "Whether quarantine policy is enabled. Only supported on Premium SKU"
  type        = bool
  default     = false
}

variable "retention_policy_in_days" {
  description = "Number of days to retain untagged manifests. Only supported on Premium SKU. Set to null to disable"
  type        = number
  default     = null
}

variable "zone_redundancy_enabled" {
  description = "Whether zone redundancy is enabled. Only supported on Premium SKU. Changing forces new resource"
  type        = bool
  default     = false
}
