output "cluster_id" {
  description = "The ID of the created cluster"
  value       = local.output_map["CLUSTER_ID"]
}

output "tenant_name" {
  description = "The name of the tenant"
  value       = local.output_map["TENANT_NAME"]
}

output "cluster_token" {
  description = "The token for the cluster"
  value       = local.output_map["CLUSTER_TOKEN"]
  sensitive   = true
}
output "provider_integration_enabled" {
  description = "Whether the provider integration is enabled"
  value       = local.provider_integration_enabled
}
