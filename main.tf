resource "null_resource" "create_cluster" {
  triggers = {
<<<<<<< HEAD
    cluster_name  = var.cluster_name
    cluster_type  = var.cluster_type
    always_update = var.always_update ? timestamp() : "initial"
||||||| parent of fe521d0 (update trigger update variable)
    cluster_name        = var.cluster_name
    cluster_type        = var.cluster_type
    trigger_helm_update = var.trigger_helm_update ? timestamp() : "initial"
=======
    cluster_name = var.cluster_name
    cluster_type = var.cluster_type
    always_apply = var.always_apply ? timestamp() : "initial"
>>>>>>> fe521d0 (update trigger update variable)
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
