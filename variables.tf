variable "control_plane_url" {
  type        = string
  description = "URL of the control plane"
}

variable "api_key" {
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

variable "account_id" {
  type        = string
  description = "Cloud provider account ID"
}

variable "region" {
  type        = string
  description = "Region name"
}


variable "platform_user_enabled" {
  type        = bool
  description = "Flag to enable/disable platform user"
}

variable "platform_user_access_key" {
  type        = string
  description = "AWS access key for the platform user"
  sensitive   = true
}

variable "platform_user_secret_key" {
  type        = string
  description = "AWS secret key for the platform user"
  sensitive   = true
}

variable "platform_iam_role_arn" {
  type        = string
  description = "ARN of the IAM role for the platform"
}


variable "s3_enabled" {
  type        = bool
  description = "Flag to enable/disable S3 integration"
  default     = false
}

variable "platform_user_bucket_name" {
  type        = string
  description = "Name of the S3 bucket for platform user"
}

variable "ecr_enabled" {
  type        = bool
  description = "Flag to enable/disable ECR integration"
  default     = false
}

variable "parameter_store_enabled" {
  type        = bool
  description = "Flag to enable/disable Parameter Store integration"
  default     = false
}

variable "secrets_manager_enabled" {
  type        = bool
  description = "Flag to enable/disable Secrets Manager integration"
  default     = false
}

variable "cluster_integration_enabled" {
  type        = bool
  description = "Flag to enable/disable cluster integration"
  default     = false
}

variable "trigger_helm_update" {
  type        = string
  description = "Trigger Helm update"
  default     = null
}
