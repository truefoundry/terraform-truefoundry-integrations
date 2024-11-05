# Common Required Variables
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
  description = "Type of cluster to create (aws-eks, azure-aks, or gcp-gke-standard)"
  validation {
    condition     = contains(["aws-eks", "azure-aks", "gcp-gke-standard"], var.cluster_type)
    error_message = "cluster_type must be one of: aws-eks, azure-aks, gcp-gke-standard"
  }
}

# Common Optional Variables
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

# AWS Specific Variables
variable "cloud_account_id" {
  type        = string
  description = "Cloud provider account ID/Project ID/Subscription ID"
  default     = null
}

variable "cloud_region" {
  type        = string
  description = "Cloud provider region name"
  default     = null
}

variable "service_account_enabled" {
  type        = bool
  description = "Flag to enable/disable service account/platform user"
  default     = false
}

variable "service_account_key_id" {
  type        = string
  description = "Cloud provider service account key ID/access key/client ID"
  sensitive   = true
  default     = null
}

variable "service_account_key_secret" {
  type        = string
  description = "Cloud provider service account key secret/access secret/client secret"
  sensitive   = true
  default     = null
}

variable "service_account_role_arn" {
  type        = string
  description = "Cloud provider service account role ARN/role ID/role name"
  default     = null
}

variable "object_store_enabled" {
  type        = bool
  description = "Flag to enable/disable object storage integration (S3/GCS/Blob Storage)"
  default     = false
}

variable "object_store_bucket_name" {
  type        = string
  description = "Name of the object storage bucket"
  default     = null
}

variable "container_registry_enabled" {
  type        = bool
  description = "Flag to enable/disable container registry integration (ECR/GCR/ACR)"
  default     = false
}

variable "secret_store_enabled" {
  type        = bool
  description = "Flag to enable/disable secret store integration"
  default     = false
}

# Azure Specific Variables
variable "container_registry_admin_password" {
  type        = string
  description = "Admin password for Azure Container Registry"
  sensitive   = true
  default     = null
}

variable "container_registry_admin_username" {
  type        = string
  description = "Admin username for Azure Container Registry"
  default     = null
}

variable "container_registry_login_server" {
  type        = string
  description = "Login server URL for Azure Container Registry"
  default     = null
}

variable "blob_storage_enabled" {
  type        = bool
  description = "Flag to enable/disable Azure Blob Storage integration"
  default     = false
}

variable "blob_storage_connection_string" {
  type        = string
  description = "Connection string for Azure Blob Storage"
  sensitive   = true
  default     = null
}

variable "blob_storage_root_url" {
  type        = string
  description = "Root URL for Azure Blob Storage"
  default     = null
}

# GCP Specific Variables
variable "serviceaccount_key_type" {
  type        = string
  description = "Type of GCP service account key"
  default     = null
}

variable "serviceaccount_key_client_id" {
  type        = string
  description = "Client ID for GCP service account"
  default     = null
}

variable "serviceaccount_key_client_email" {
  type        = string
  description = "Client email for GCP service account"
  default     = null
}

variable "serviceaccount_key_private_key" {
  type        = string
  description = "Private key for GCP service account"
  sensitive   = true
  default     = null
}

variable "serviceaccount_key_project_id" {
  type        = string
  description = "Project ID for GCP service account"
  default     = null
}

variable "serviceaccount_key_auth_uri" {
  type        = string
  description = "Auth URI for GCP service account"
  default     = "https://accounts.google.com/o/oauth2/auth"
}

variable "serviceaccount_key_token_uri" {
  type        = string
  description = "Token URI for GCP service account"
  default     = "https://oauth2.googleapis.com/token"
}

variable "serviceaccount_key_auth_provider_x509_cert_url" {
  type        = string
  description = "Auth provider x509 cert URL for GCP service account"
  default     = "https://www.googleapis.com/oauth2/v1/certs"
}

variable "serviceaccount_key_client_x509_cert_url" {
  type        = string
  description = "Client x509 cert URL for GCP service account"
  default     = null
}

variable "serviceaccount_key_universe_domain" {
  type        = string
  description = "Universe domain for GCP service account"
  default     = "googleapis.com"
}

variable "artifact_registry_url" {
  type        = string
  description = "URL for GCP Artifact Registry"
  default     = null
}

variable "bucket_url" {
  type        = string
  description = "URL for GCP Storage bucket"
  default     = null
}

variable "cluster_integration_client_id" {
  type        = string
  description = "Client ID for Azure cluster integration"
  default     = null
}

variable "cluster_integration_client_secret" {
  type        = string
  description = "Client secret for Azure cluster integration"
  sensitive   = true
  default     = null
}

variable "cluster_integration_tenant_id" {
  type        = string
  description = "Tenant ID for Azure cluster integration"
  default     = null
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
  default     = null
}
