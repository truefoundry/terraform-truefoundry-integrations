##################################################################################
## Core Configuration Variables
##################################################################################
# 
variable "control_plane_url" {
  type        = string
  description = "URL of the TrueFoundry control plane (e.g., 'https://app.truefoundry.com')"
}

variable "tfy_api_key" {
  type        = string
  description = "TrueFoundry API key for authentication. Can be obtained from the TrueFoundry console."
  sensitive   = true
}

variable "cluster_name" {
  type        = string
  description = "Name of the Kubernetes cluster to create or manage. Must be unique within your organization."
}

variable "cluster_type" {
  type        = string
  description = "Type of cluster to create (aws-eks, azure-aks, gcp-gke-standard)"
  validation {
    condition     = contains(["aws-eks", "azure-aks", "gcp-gke-standard"], var.cluster_type)
    error_message = "cluster_type must be one of: aws-eks, azure-aks, gcp-gke-standard"
  }
}

variable "always_update" {
  type        = bool
  description = "Forces cluster configuration updates on every terraform apply, even without changes. Use with caution as it may cause unnecessary updates."
  default     = false
}

variable "stdout_log_file" {
  type        = string
  description = "Log file of stdout"
  default     = "truefoundry-cluster.stdout"
}

variable "stderr_log_file" {
  type        = string
  description = "Log file of stdout"
  default     = "truefoundry-cluster.stderr"
}

##################################################################################
## AWS
##################################################################################
# 
variable "aws_account_id" {
  type        = string
  description = "AWS Account ID where the EKS cluster will be created (e.g., '123456789012')"
  default     = null
}

variable "aws_region" {
  type        = string
  description = "AWS Region where resources will be created (e.g., 'us-west-2')"
  default     = null
}

variable "aws_platform_features_user_enabled" {
  type        = bool
  description = "Enable AWS IAM user-based authentication. If true, requires aws_platform_features_user_access_key_id and aws_platform_features_user_secret_access_key."
  default     = false
}

variable "aws_platform_features_user_access_key_id" {
  type        = string
  description = "AWS IAM Access Key ID for user-based authentication. Required if aws_platform_features_user_enabled is true."
  sensitive   = true
  default     = null
}

variable "aws_platform_features_user_secret_access_key" {
  type        = string
  description = "AWS IAM Secret Access Key for user-based authentication. Required if aws_platform_features_user_enabled is true."
  sensitive   = true
  default     = null
}

variable "aws_platform_features_role_arn" {
  type        = string
  description = "AWS IAM Role ARN for role-based authentication (e.g., 'arn:aws:iam::123456789012:role/TrueFoundryRole')"
  default     = null
}

variable "aws_s3_enabled" {
  type        = bool
  description = "Enable AWS S3 integration for cluster storage capabilities"
  default     = true
}

variable "aws_s3_bucket_name" {
  type        = string
  description = "Name of the S3 bucket to use for cluster storage. Required if aws_s3_enabled is true."
  default     = null
}

variable "aws_ecr_enabled" {
  type        = bool
  description = "Enable AWS Elastic Container Registry (ECR) integration for container image storage"
  default     = true
}

variable "aws_parameter_store_enabled" {
  type        = bool
  description = "Enable AWS Systems Manager Parameter Store integration for secret management"
  default     = true
}

variable "aws_secrets_manager_enabled" {
  type        = bool
  description = "Enable AWS Secrets Manager integration for enhanced secrets management capabilities"
  default     = false
}

variable "aws_cluster_integration_enabled" {
  type        = bool
  description = "Enable direct integration with AWS EKS cluster services"
  default     = true
}

##################################################################################
## Azure
##################################################################################
# 
variable "azure_subscription_id" {
  type        = string
  description = "Azure Subscription ID where the AKS cluster will be created (e.g., '12345678-1234-1234-1234-123456789012')"
  default     = null
}

variable "azure_resource_group_name" {
  type        = string
  description = "Name of the Azure Resource Group where the AKS cluster will be created"
  default     = null
}

variable "azure_cluster_integration_enabled" {
  type        = bool
  description = "Enable direct integration with Azure AKS cluster services"
  default     = true
}

variable "azure_client_id" {
  type        = string
  description = "Azure Service Principal Client ID for authentication"
  default     = null
}

variable "azure_client_secret" {
  type        = string
  description = "Azure Service Principal Client Secret for authentication"
  sensitive   = true
  default     = null
}

variable "azure_tenant_id" {
  type        = string
  description = "Azure Tenant ID associated with the subscription"
  default     = null
}

variable "azure_acr_enabled" {
  type        = bool
  description = "Enable Azure Container Registry (ACR) integration for container image storage"
  default     = true
}

variable "azure_acr_admin_password" {
  type        = string
  description = "Admin password for Azure Container Registry. Required if azure_acr_enabled is true."
  sensitive   = true
  default     = null
}

variable "azure_acr_admin_username" {
  type        = string
  description = "Admin username for Azure Container Registry. Required if azure_acr_enabled is true."
  default     = null
}

variable "azure_acr_login_server" {
  type        = string
  description = "Azure Container Registry login server URL (e.g., 'myregistry.azurecr.io')"
  default     = null
}

variable "azure_blob_storage_enabled" {
  type        = bool
  description = "Enable Azure Blob Storage integration for cluster storage capabilities"
  default     = true
}

variable "azure_blob_storage_connection_string" {
  type        = string
  description = "Connection string for Azure Storage Account. Required if azure_blob_storage_enabled is true."
  sensitive   = true
  default     = null
}

variable "azure_blob_storage_root_url" {
  type        = string
  description = "Root URL for Azure Storage Account (e.g., 'https://mystorageaccount.blob.core.windows.net')"
  default     = null
}

##################################################################################
## GCP
##################################################################################
# 
variable "gcp_project_id" {
  type        = string
  description = "GCP Project ID where the GKE cluster will be created"
  default     = null
}

variable "gcp_artifact_registry_url" {
  type        = string
  description = "URL for GCP Artifact Registry (e.g., 'LOCATION-docker.pkg.dev/PROJECT_ID')"
  default     = null
}

variable "gcp_storage_bucket_url" {
  type        = string
  description = "URL for GCP Storage bucket (e.g., 'gs://bucket-name')"
  default     = null
}

variable "gcp_cluster_integration_enabled" {
  type        = bool
  description = "Enable direct integration with GCP GKE cluster services"
  default     = true
}

variable "gcp_blob_storage_enabled" {
  type        = bool
  description = "Enable GCP Blob Storage integration for cluster storage capabilities"
  default     = true
}

variable "gcp_secrets_manager_enabled" {
  type        = bool
  description = "Enable GCP Secrets Manager integration for secret management"
  default     = true
}

variable "gcp_container_registry_enabled" {
  type        = bool
  description = "Enable GCP Container Registry integration for container image storage"
  default     = true
}

variable "gcp_region" {
  type        = string
  description = "GCP Region where the GKE cluster is located"
  default     = null
}

variable "gcp_sa_auth_data" {
  type        = string
  description = "GCP Service Account auth_data"
  default     = null
}

variable "tenant_name" {
  type        = string
  description = "Name of the tenant"
  default     = null
}
