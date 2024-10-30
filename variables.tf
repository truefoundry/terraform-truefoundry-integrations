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

# variable "platform_features" {
#   type = object({
#     platform_user_enabled     = bool
#     platform_user_access_key  = optional(string)
#     platform_user_secret_key  = optional(string)
#     platform_iam_role_arn     = optional(string)
#     platform_user_bucket_name = optional(string)

#     # Azure specific
#     container_registry = optional(object({
#       admin_password = string
#       admin_username = string
#       login_server   = string
#     }))
#     blob_storage = optional(object({
#       connection_string = string
#       root_url          = string
#     }))
#     cluster_integration = optional(object({
#       application_client_id = string
#       tenant_id             = string
#       client_secret         = string
#     }))

#     # GCP specific
#     serviceaccount_key = optional(object({
#       type                        = string
#       project_id                  = string
#       private_key_id              = string
#       private_key                 = string
#       client_email                = string
#       client_id                   = string
#       auth_uri                    = string
#       token_uri                   = string
#       auth_provider_x509_cert_url = string
#       client_x509_cert_url        = string
#       universe_domain             = string
#     }))
#     artifact_registry_url = optional(string)
#     bucket_url            = optional(string)
#   })
#   description = "Platform features configuration"
# }

# variable "cloud_config" {
#   type = object({
#     # AWS specific
#     s3_enabled                  = optional(bool)
#     ecr_enabled                 = optional(bool)
#     parameter_store_enabled     = optional(bool)
#     secrets_manager_enabled     = optional(bool)
#     cluster_integration_enabled = optional(bool)

#     # Azure specific
#     subscription_id = optional(string)
#     resource_group  = optional(string)

#     # GCP specific
#     project_id = optional(string)
#   })
#   description = "Cloud provider specific configuration"
# }


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
