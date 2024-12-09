locals {
  provider_template = {
    "aws-eks"          = "${path.module}/templates/aws.json.tpl"
    "azure-aks"        = "${path.module}/templates/azure.json.tpl"
    "gcp-gke-standard" = "${path.module}/templates/gcp.json.tpl"
  }

  # AWS provider configuration
  aws_config = {
    cluster_name     = var.cluster_name
    cloud_account_id = var.aws_account_id
    cloud_region     = var.aws_region

    // Auth related
    platform_features_user_enabled    = var.aws_platform_features_user_enabled
    platform_features_user_key_id     = var.aws_platform_features_user_access_key_id
    platform_features_user_key_secret = var.aws_platform_features_user_secret_access_key
    platform_features_role_arn        = var.aws_platform_features_role_arn

    // Feature flags
    object_store_enabled        = var.aws_s3_enabled
    object_store_bucket_name    = var.aws_s3_bucket_name
    container_registry_enabled  = var.aws_ecr_enabled
    parameter_store_enabled     = var.aws_parameter_store_enabled
    secrets_manager_enabled     = var.aws_secrets_manager_enabled
    cluster_integration_enabled = var.aws_cluster_integration_enabled
  }

  # Azure provider configuration
  azure_config = {
    cluster_name                      = var.cluster_name
    subscription_id                   = var.azure_subscription_id
    resource_group_name               = var.azure_resource_group_name
    cluster_integration_enabled       = var.azure_cluster_integration_enabled
    cluster_integration_client_id     = var.azure_client_id
    cluster_integration_client_secret = var.azure_client_secret
    cluster_integration_tenant_id     = var.azure_tenant_id
    container_registry_enabled        = var.azure_acr_enabled
    container_registry_admin_password = var.azure_acr_admin_password
    container_registry_admin_username = var.azure_acr_admin_username
    container_registry_login_server   = var.azure_acr_login_server
    blob_storage_enabled              = var.azure_blob_storage_enabled
    blob_storage_connection_string    = var.azure_blob_storage_connection_string
    blob_storage_root_url             = var.azure_blob_storage_root_url
  }

  # GCP provider configuration
  gcp_config = {
    cluster_name                = var.cluster_name
    project_id                  = var.gcp_project_id
    region                      = var.gcp_region
    sa_auth_data                = var.gcp_sa_auth_data
    container_registry_enabled  = var.gcp_container_registry_enabled
    blob_storage_enabled        = var.gcp_blob_storage_enabled
    secrets_manager_enabled     = var.gcp_secrets_manager_enabled
    cluster_integration_enabled = var.gcp_cluster_integration_enabled
    artifact_registry_url       = var.gcp_artifact_registry_url
    bucket_url                  = var.gcp_storage_bucket_url
  }

  # Default configuration
  default_config = {
    cluster_name = var.cluster_name
  }

  # Select appropriate configuration based on cluster type
  provider_config = var.cluster_type == "generic" ? "" : templatefile(
    local.provider_template[var.cluster_type],
    var.cluster_type == "aws-eks" ? local.aws_config : (
      var.cluster_type == "azure-aks" ? local.azure_config : (
        var.cluster_type == "gcp-gke-standard" ? local.gcp_config : local.default_config
      )
    )
  )

  # Update the output_map to use the external data source
  output_map = {
    "CLUSTER_ID"    = data.external.create_cluster.result.cluster_id
    "CLUSTER_TOKEN" = data.external.create_cluster.result.cluster_token
    "TENANT_NAME"   = data.external.create_cluster.result.tenant_name
  }
}
