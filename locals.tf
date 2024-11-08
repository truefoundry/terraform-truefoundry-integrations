locals {
  provider_config = templatefile("${path.module}/templates/aws_provider.json.tpl", {
    cluster_name                = var.cluster_name
    service_account_enabled     = var.service_account_enabled
    service_account_key_id      = var.service_account_key_id
    service_account_key_secret  = var.service_account_key_secret
    service_account_role_arn    = var.service_account_role_arn
    cloud_account_id            = var.cloud_account_id
    cloud_region                = var.cloud_region
    object_store_enabled        = var.object_store_enabled
    object_store_bucket_name    = var.object_store_bucket_name
    container_registry_enabled  = var.container_registry_enabled
    secret_store_enabled        = var.secret_store_enabled
    key_vault_enabled           = var.key_vault_enabled
    cluster_integration_enabled = var.cluster_integration_enabled
  })

  output_file = "${path.module}/outputs/cluster_output.txt"
}