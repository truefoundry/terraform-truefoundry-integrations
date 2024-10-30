output "cluster_id" {
  value       = local.output_map["CLUSTER_ID"]
  description = "ID of the created cluster"
}

output "cluster_token" {
  value       = local.output_map["CLUSTER_TOKEN"]
  description = "Token for the created cluster"
  sensitive   = true
}

output "tenant_name" {
  value       = local.output_map["TENANT_NAME"]
  description = "Name of the tenant"
}
