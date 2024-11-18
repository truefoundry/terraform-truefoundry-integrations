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
variable "always_apply" {
  type        = bool
  description = "If set to true, forces the cluster configuration to be applied on every terraform apply, even if there are no changes"
  default     = false
}

# AWS Variables
variable "aws_account_id" {
  type        = string
  description = "AWS Account ID"
  default     = null
}

variable "aws_region" {
  type        = string
  description = "AWS Region name"
  default     = null
}

variable "aws_service_account_enabled" {
  type        = bool
  description = "Flag to enable/disable AWS IAM service account"
  default     = false
}

variable "aws_access_key_id" {
  type        = string
  description = "AWS IAM Access Key ID"
  sensitive   = true
  default     = null
}

variable "aws_secret_access_key" {
  type        = string
  description = "AWS IAM Secret Access Key"
  sensitive   = true
  default     = null
}

variable "aws_role_arn" {
  type        = string
  description = "AWS IAM Role ARN"
  default     = null
}

variable "aws_s3_enabled" {
  type        = bool
  description = "Flag to enable/disable AWS S3 integration"
  default     = false
}

variable "aws_s3_bucket_name" {
  type        = string
  description = "AWS S3 bucket name"
  default     = null
}

variable "aws_ecr_enabled" {
  type        = bool
  description = "Flag to enable/disable AWS ECR integration"
  default     = false
}

variable "aws_parameter_store_enabled" {
  type        = bool
  description = "Flag to enable/disable AWS Parameter Store integration"
  default     = false
}

variable "aws_secrets_manager_enabled" {
  type        = bool
  description = "Flag to enable AWS Secrets Manager integration"
  default     = false
}

variable "aws_cluster_integration_enabled" {
  type        = bool
  description = "Flag to enable/disable AWS EKS cluster integration"
  default     = false
}

# Azure Variables
variable "azure_subscription_id" {
  type        = string
  description = "Azure Subscription ID"
  default     = null
}

variable "azure_resource_group_name" {
  type        = string
  description = "Azure Resource Group name"
  default     = null
}

variable "azure_cluster_integration_enabled" {
  type        = bool
  description = "Flag to enable/disable Azure AKS cluster integration"
  default     = false
}

variable "azure_client_id" {
  type        = string
  description = "Azure Service Principal Client ID"
  default     = null
}

variable "azure_client_secret" {
  type        = string
  description = "Azure Service Principal Client Secret"
  sensitive   = true
  default     = null
}

variable "azure_tenant_id" {
  type        = string
  description = "Azure Tenant ID"
  default     = null
}

variable "azure_acr_enabled" {
  type        = bool
  description = "Flag to enable/disable Azure Container Registry integration"
  default     = false
}

variable "azure_acr_admin_password" {
  type        = string
  description = "Azure Container Registry admin password"
  sensitive   = true
  default     = null
}

variable "azure_acr_admin_username" {
  type        = string
  description = "Azure Container Registry admin username"
  default     = null
}

variable "azure_acr_login_server" {
  type        = string
  description = "Azure Container Registry login server URL"
  default     = null
}

variable "azure_storage_enabled" {
  type        = bool
  description = "Flag to enable/disable Azure Blob Storage integration"
  default     = false
}

variable "azure_storage_connection_string" {
  type        = string
  description = "Azure Storage Account connection string"
  sensitive   = true
  default     = null
}

variable "azure_storage_root_url" {
  type        = string
  description = "Azure Storage Account root URL"
  default     = null
}

# GCP Variables
variable "gcp_project_id" {
  type        = string
  description = "GCP Project ID"
  default     = null
}

variable "gcp_sa_key_type" {
  type        = string
  description = "GCP Service Account key type"
  default     = null
}

variable "gcp_sa_client_id" {
  type        = string
  description = "GCP Service Account client ID"
  default     = null
}

variable "gcp_sa_client_email" {
  type        = string
  description = "GCP Service Account client email"
  default     = null
}

variable "gcp_sa_private_key" {
  type        = string
  description = "GCP Service Account private key"
  sensitive   = true
  default     = null
}

variable "gcp_sa_project_id" {
  type        = string
  description = "GCP Service Account project ID"
  default     = null
}

variable "gcp_sa_auth_uri" {
  type        = string
  description = "GCP Service Account auth URI"
  default     = "https://accounts.google.com/o/oauth2/auth"
}

variable "gcp_sa_token_uri" {
  type        = string
  description = "GCP Service Account token URI"
  default     = "https://oauth2.googleapis.com/token"
}

variable "gcp_sa_auth_provider_cert_url" {
  type        = string
  description = "GCP Service Account auth provider cert URL"
  default     = "https://www.googleapis.com/oauth2/v1/certs"
}

variable "gcp_sa_client_cert_url" {
  type        = string
  description = "GCP Service Account client cert URL"
  default     = null
}

variable "gcp_sa_universe_domain" {
  type        = string
  description = "GCP Service Account universe domain"
  default     = "googleapis.com"
}

variable "gcp_artifact_registry_url" {
  type        = string
  description = "GCP Artifact Registry URL"
  default     = null
}

variable "gcp_storage_bucket_url" {
  type        = string
  description = "GCP Storage bucket URL"
  default     = null
}

