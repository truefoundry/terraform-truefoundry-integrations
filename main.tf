resource "null_resource" "create_cluster" {
  triggers = {
    cluster_name  = var.cluster_name
    cluster_type  = var.cluster_type
    always_update = var.always_update ? timestamp() : "initial"
  }

  provisioner "local-exec" {
    command = <<-EOT
      mkdir -p ${dirname(local.output_file)}
      touch ${local.output_file}
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

# Add data source to read the output file after creation
data "local_file" "cluster_output" {
  depends_on = [null_resource.create_cluster]
  filename   = local.output_file
}
