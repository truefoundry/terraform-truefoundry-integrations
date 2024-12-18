{
  "manifest": {
    "name": "${cluster_name}",
    "type": "provider-account/azure",
    "subscription_id": "${subscription_id}",
    "authorized_subjects": [
      "team:everyone"
    ],
    "integrations": [
      %{ if container_registry_enabled }
      {
        "name": "registry",
        "type": "integration/docker-registry/azure/acr",
        "auth_data": {
          "type": "basic-auth",
          "password": "${container_registry_admin_password}",
          "username": "${container_registry_admin_username}"
        },
        "authorized_subjects": [
          "team:everyone"
        ],
        "registry_url": "${container_registry_login_server}"
      }%{ endif }
      %{ if container_registry_enabled && blob_storage_enabled },%{ endif }
      %{ if blob_storage_enabled }
      {
        "name": "blob",
        "type": "integration/blob-storage/azure/blob",
        "auth_data": {
          "type": "connection-string",
          "connection_string": "${blob_storage_connection_string}"
        },
        "authorized_subjects": [
      "team:everyone"
    ],
        "storage_root": "${blob_storage_root_url}"
      }%{ endif }
      %{ if (container_registry_enabled || blob_storage_enabled) && cluster_integration_enabled },%{ endif }
      %{ if cluster_integration_enabled }
      {
        "name": "cluster-integration",
        "type": "integration/cluster/azure/aks",
        "auth_data": {
          "type": "oauth",
          "client_id": "${cluster_integration_client_id}",
          "tenant_id": "${cluster_integration_tenant_id}",
          "client_secret": "${cluster_integration_client_secret}",
          "subscription_id": "${subscription_id}"
        },
        "authorized_subjects": [
          "team:everyone"
        ],
        "cluster_name": "${cluster_name}",
        "resource_group": "${resource_group_name}",
        "tfy_cluster_id": "${cluster_name}"
      }%{ endif }
    ]
  }
}