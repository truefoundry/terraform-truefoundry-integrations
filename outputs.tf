output "cluster_id" {
  description = "The ID of the created cluster"
  value       = try(local.output_map["CLUSTER_ID"], null)
}

output "tenant_name" {
  description = "The name of the tenant"
  value       = try(local.output_map["TENANT_NAME"], null)
}

output "cluster_token" {
  description = "The token for the cluster"
  value       = try(local.output_map["CLUSTER_TOKEN"], null)
  sensitive   = true
}
