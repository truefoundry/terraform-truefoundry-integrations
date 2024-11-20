resource "null_resource" "create_cluster" {
  triggers = {
    cluster_name  = var.cluster_name
    cluster_type  = var.cluster_type
    always_update = var.always_update ? timestamp() : "initial"
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
  output_lines = compact(split("\n", data.local_file.cluster_output.content))
  output_map = { for line in local.output_lines :
    split("::", line)[0] => split("::", line)[1]
    if length(split("::", line)) == 2
  }
}
