# Replace the null_resource and local_file data source with external data source
data "external" "create_cluster" {
  program = ["bash", "${path.module}/scripts/setup_truefoundry_cluster.sh"]

  query = {
    control_plane_url      = var.control_plane_url
    api_key                = var.tfy_api_key
    cluster_name           = var.cluster_name
    cluster_type           = var.cluster_type
    provider_config_base64 = base64encode(local.provider_config)
    always_update          = var.always_update ? timestamp() : "initial"
  }
}
