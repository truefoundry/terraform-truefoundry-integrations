variable "control_plane_url" {
  type        = string
  description = "URL of the control plane"
}

variable "tfy_api_key" {
  type        = string
  description = "API key for authentication"
  sensitive   = true
}

variable "cluster_name" {
  type        = string
  description = "Name of the cluster to create"
}

variable "cluster_type" {
  type        = string
  description = "Type of cluster to create"
}

variable "cloud_account_id" {
  type        = string
  description = "Cloud provider account ID/Project ID/Subscription ID"
}

variable "cloud_region" {
  type        = string
  description = "Cloud provider region name"
}

variable "service_account_enabled" {
  type        = bool
  description = "Flag to enable/disable service account/platform user"
}

# Credentials
variable "service_account_key_id" {
  type        = string
  description = "Cloud provider service account key ID/access key/client ID"
  sensitive   = true
}

variable "service_account_key_secret" {
  type        = string
  description = "Cloud provider service account key secret/access secret/client secret"
  sensitive   = true
}

variable "service_account_role_arn" {
  type        = string
  description = "Cloud provider service account role ARN/role ID/role name"
}

# Storage
variable "object_store_enabled" {
  type        = bool
  description = "Flag to enable/disable object storage integration (S3/GCS/Blob Storage)"
  default     = false
}

variable "object_store_bucket_name" {
  type        = string
  description = "Name of the object storage bucket"
}

# Container Registry
variable "container_registry_enabled" {
  type        = bool
  description = "Flag to enable/disable container registry integration (ECR/GCR/ACR)"
  default     = false
}

# Secret Management
variable "secret_store_enabled" {
  type        = bool
  description = "Flag to enable/disable secret store integration (Parameter Store/Secret Manager/Key Vault)"
  default     = false
}

variable "key_vault_enabled" {
  type        = bool
  description = "Flag to enable/disable key vault integration (Secrets Manager/KMS/Key Vault)"
  default     = false
}

variable "cluster_integration_enabled" {
  type        = bool
  description = "Flag to enable/disable cluster integration"
  default     = false
}

variable "trigger_helm_update" {
  type        = bool
  description = "Trigger Helm update"
  default     = false
}
