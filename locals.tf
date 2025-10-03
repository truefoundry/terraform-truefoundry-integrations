locals {

  provider_integration_enabled = var.cluster_type == "gcp-gke-standard" ? var.gcp_service_account_key_enabled && var.gcp_service_account_enabled : (
    var.cluster_type == "aws-eks" ? var.aws_platform_features_iam_role_enabled || var.aws_platform_features_user_enabled : true
  )
  provider_account_template = {
    "aws-eks"          = "${path.module}/templates/provider-account/aws.json.tpl"
    "azure-aks"        = "${path.module}/templates/provider-account/azure.json.tpl"
    "gcp-gke-standard" = "${path.module}/templates/provider-account/gcp.json.tpl"
  }

  # AWS provider configuration
  aws_provider_account_config = {
    cluster_name     = var.cluster_name
    cloud_account_id = var.aws_account_id
    cloud_region     = var.aws_region

    // Auth related
    platform_features_user_enabled     = var.aws_platform_features_user_enabled
    platform_features_user_key_id      = var.aws_platform_features_user_access_key_id
    platform_features_user_key_secret  = var.aws_platform_features_user_secret_access_key
    platform_features_iam_role_enabled = var.aws_platform_features_iam_role_enabled
    platform_features_role_arn         = var.aws_platform_features_role_arn

    // Feature flags
    object_store_enabled        = var.aws_s3_enabled
    object_store_bucket_name    = var.aws_s3_bucket_name
    container_registry_enabled  = var.aws_ecr_enabled
    parameter_store_enabled     = var.aws_parameter_store_enabled
    secrets_manager_enabled     = var.aws_secrets_manager_enabled
    cluster_integration_enabled = var.aws_cluster_integration_enabled
  }

  # Azure provider configuration
  azure_provider_account_config = {
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
  gcp_provider_account_config = {
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
  default_provider_account_config = {
    cluster_name = var.cluster_name
  }

  # Select appropriate configuration based on cluster type
  provider_account_config = templatefile(
    local.provider_account_template[var.cluster_type],
    var.cluster_type == "aws-eks" ? local.aws_provider_account_config : (
      var.cluster_type == "azure-aks" ? local.azure_provider_account_config : (
        var.cluster_type == "gcp-gke-standard" ? local.gcp_provider_account_config : local.default_provider_account_config
      )
    )
  )


  cluster_template = {
    "aws-eks"          = "${path.module}/templates/cluster/aws.json.tpl"
    "azure-aks"        = "${path.module}/templates/cluster/azure.json.tpl"
    "gcp-gke-standard" = "${path.module}/templates/cluster/gcp.json.tpl"
  }

  # AWS provider configuration
  aws_cluster_config = {
    cluster_name                 = var.cluster_name
    cluster_type                 = "aws-eks"
    env_name                     = data.external.get_environment.result.environment_name
    tenant_name                  = data.external.get_environment.result.tenant_name
    account_type                 = "aws"
    container_registry_enabled   = var.aws_ecr_enabled
    cluster_integration_enabled  = var.aws_cluster_integration_enabled
    provider_integration_enabled = local.provider_integration_enabled
  }

  # Azure provider configuration
  azure_cluster_config = {
    cluster_name                = var.cluster_name
    cluster_type                = "azure-aks"
    env_name                    = data.external.get_environment.result.environment_name
    tenant_name                 = data.external.get_environment.result.tenant_name
    account_type                = "azure"
    container_registry_enabled  = var.azure_acr_enabled
    cluster_integration_enabled = var.azure_cluster_integration_enabled
  }

  # GCP provider configuration
  gcp_cluster_config = {
    cluster_name                 = var.cluster_name
    cluster_type                 = "gcp-gke-standard"
    env_name                     = data.external.get_environment.result.environment_name
    tenant_name                  = data.external.get_environment.result.tenant_name
    account_type                 = "gcp"
    container_registry_enabled   = var.gcp_container_registry_enabled
    cluster_integration_enabled  = var.gcp_cluster_integration_enabled
    provider_integration_enabled = local.provider_integration_enabled
  }

  cluster_config = templatefile(
    local.cluster_template[var.cluster_type],
    var.cluster_type == "aws-eks" ? local.aws_cluster_config : (
      var.cluster_type == "azure-aks" ? local.azure_cluster_config : (
        var.cluster_type == "gcp-gke-standard" ? local.gcp_cluster_config : null
      )
    )
  )

  # Update the output_map to use the external data source
  output_map = {
    "CLUSTER_ID"    = data.external.create_cluster.result.cluster_id
    "CLUSTER_TOKEN" = data.external.create_cluster.result.cluster_token
    "TENANT_NAME"   = data.external.get_environment.result.tenant_name
  }
}
