# Replace the null_resource and local_file data source with external data source

data "external" "get_environment" {
  program = ["bash", "${path.module}/scripts/get_environment.sh"]

  query = {
    control_plane_url = var.control_plane_url
    api_key           = var.tfy_api_key
    tenant_name       = var.tenant_name
    stdout_log_file   = var.stdout_log_file
    stderr_log_file   = var.stderr_log_file
    always_update     = var.always_update ? timestamp() : "initial"
  }
}

data "external" "create_cluster" {
  program    = ["bash", "${path.module}/scripts/setup_truefoundry_cluster.sh"]
  depends_on = [data.external.get_environment]
  query = {
    control_plane_url            = var.control_plane_url
    api_key                      = var.tfy_api_key
    cluster_name                 = var.cluster_name
    cluster_type                 = var.cluster_type
    provider_integration_enabled = var.provider_integration_enabled
    cluster_config_base64        = base64encode(local.cluster_config)
    provider_config_base64       = base64encode(local.provider_account_config)
    stdout_log_file              = var.stdout_log_file
    stderr_log_file              = var.stderr_log_file
    always_update                = var.always_update ? timestamp() : "initial"
  }
}
