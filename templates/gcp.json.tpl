{
  "manifest": {
    "name": "${cluster_name}",
    "type": "provider-account/gcp",
    "auth_data": {
      "key_file_content": ${sa_auth_data},
      "type": "key-file"
    },
    "project_id": "${project_id}",
    "integrations": [
      %{ if container_registry_enabled }
      {
        "name": "registry",
        "type": "integration/docker-registry/gcp/gcr",
        "registry_url": "${artifact_registry_url}",
        "authorized_subjects": [
          "team:everyone"
        ]
      }%{ endif }
      %{ if container_registry_enabled && blob_storage_enabled },%{ endif }
      %{ if blob_storage_enabled }
      {
        "name": "blob",
        "type": "integration/blob-storage/gcp/gcs",
        "storage_root": "${bucket_url}",
        "authorized_subjects": [
          "team:everyone"
        ]
      }%{ endif }
      %{ if (container_registry_enabled || blob_storage_enabled) && secrets_manager_enabled },%{ endif }
      %{ if secrets_manager_enabled }
      {
        "name": "secrets",
        "type": "integration/secret-store/gcp/gsm",
        "authorized_subjects": [
          "team:everyone"
        ]
      }%{ endif }
      %{ if (container_registry_enabled || blob_storage_enabled || secrets_manager_enabled) && cluster_integration_enabled },%{ endif }
      %{ if cluster_integration_enabled }
      {
        "name": "cluster-integration",
        "type": "integration/cluster/gcp/gke-standard",
        "location": "${region}",
        "cluster_name": "${cluster_name}",
        "authorized_subjects": [
          "team:everyone"
        ]
      }%{ endif }
    ]
  }
}