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
    platform_user_enabled       = var.platform_user_enabled
    platform_user_access_key    = var.platform_user_access_key
    platform_user_secret_key    = var.platform_user_secret_key
    platform_iam_role_arn       = var.platform_iam_role_arn
    account_id                  = var.account_id
    region                      = var.region
    s3_enabled                  = var.s3_enabled
    platform_user_bucket_name   = var.platform_user_bucket_name
    ecr_enabled                 = var.ecr_enabled
    parameter_store_enabled     = var.parameter_store_enabled
    secrets_manager_enabled     = var.secrets_manager_enabled
    cluster_integration_enabled = var.cluster_integration_enabled
  })
}

resource "null_resource" "create_cluster" {
  triggers = {
    cluster_name = var.cluster_name
    cluster_type = var.cluster_type
  }

  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/create_cluster.sh '${var.control_plane_url}' '${var.api_key}' '${var.cluster_name}' '${var.cluster_type}' '${base64encode(local.provider_config)}'"
  }
}

data "local_file" "cluster_output" {
  filename   = "${path.module}/cluster_output.txt"
  depends_on = [null_resource.create_cluster]
}

locals {
  output_map = { for line in split("\n", data.local_file.cluster_output.content) :
    split("=", line)[0] => split("=", line)[1] if length(split("=", line)) == 2
  }
}
