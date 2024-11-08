terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

locals {
  template_file_map = {
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
    service_account_enabled    = var.aws_service_account_enabled
    service_account_key_id     = var.aws_access_key_id
    service_account_key_secret = var.aws_secret_access_key
    service_account_role_arn   = var.aws_role_arn

    // Feature flags
    object_store_enabled        = var.aws_s3_enabled
    object_store_bucket_name    = var.aws_s3_bucket_name
    container_registry_enabled  = var.aws_ecr_enabled
    secret_store_enabled        = var.aws_parameter_store_enabled
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
    blob_storage_enabled              = var.azure_storage_enabled
    blob_storage_connection_string    = var.azure_storage_connection_string
    blob_storage_root_url             = var.azure_storage_root_url
  }

  # GCP provider configuration
  gcp_config = {
    cluster_name = var.cluster_name
    project_id   = var.gcp_project_id

    serviceaccount_key_type                        = var.gcp_sa_key_type
    serviceaccount_key_client_id                   = var.gcp_sa_client_id
    serviceaccount_key_client_email                = var.gcp_sa_client_email
    serviceaccount_key_private_key                 = var.gcp_sa_private_key
    serviceaccount_key_project_id                  = var.gcp_sa_project_id
    serviceaccount_key_auth_uri                    = var.gcp_sa_auth_uri
    serviceaccount_key_token_uri                   = var.gcp_sa_token_uri
    serviceaccount_key_auth_provider_x509_cert_url = var.gcp_sa_auth_provider_cert_url
    serviceaccount_key_client_x509_cert_url        = var.gcp_sa_client_cert_url
    serviceaccount_key_universe_domain             = var.gcp_sa_universe_domain

    artifact_registry_url = var.gcp_artifact_registry_url
    bucket_url            = var.gcp_storage_bucket_url
  }

  # Default configuration
  default_config = {
    cluster_name = var.cluster_name
  }

  # Select appropriate configuration based on cluster type
  provider_config = templatefile(
    local.template_file_map[var.cluster_type],
    var.cluster_type == "aws-eks" ? local.aws_config : (
      var.cluster_type == "azure-aks" ? local.azure_config : (
        var.cluster_type == "gcp-gke-standard" ? local.gcp_config : local.default_config
      )
    )
  )

  output_file = "${path.module}/cluster_output.txt"
}

resource "null_resource" "create_cluster" {
  triggers = {
    cluster_name        = var.cluster_name
    cluster_type        = var.cluster_type
    trigger_helm_update = var.trigger_helm_update ? timestamp() : "initial"
  }

  provisioner "local-exec" {
    command = <<-EOT
      bash ${path.module}/scripts/setup_truefoundry_cluster.sh \
        '${var.control_plane_url}' \
        '${var.tfy_api_key}' \
        '${var.cluster_name}' \
        '${var.cluster_type}' \
        '${base64encode(local.provider_config)}' \
        '${local.output_file}'
    EOT
  }
}

data "local_file" "cluster_output" {
  filename   = local.output_file
  depends_on = [null_resource.create_cluster]
}

locals {
  raw_content  = data.local_file.cluster_output.content
  output_lines = compact(split("\n", local.raw_content))
  output_map = { for line in local.output_lines :
    split("::", line)[0] => split("::", line)[1]
    if length(split("::", line)) == 2
  }
}
