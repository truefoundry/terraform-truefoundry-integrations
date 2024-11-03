terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

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

  output_file = "${path.module}/cluster_output.txt"
}

resource "null_resource" "create_cluster" {

  triggers = {
    cluster_name        = var.cluster_name
    cluster_type        = var.cluster_type
    trigger_helm_update = var.trigger_helm_update != false ? timestamp() : "initial"
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
    split("::", line)[0] => split("::", line)[1] if length(split("::", line)) == 2
  }
}
