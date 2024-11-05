{
  "manifest": {
    "name": "${cluster_name}",
    "type": "provider-account/gcp",
    "auth_data": {
      "key_file_content": {
        "type": "${serviceaccount_key_type}",
        "project_id": "${serviceaccount_key_project_id}",
        "private_key_id": "${serviceaccount_key_private_key_id}",
        "private_key": "${serviceaccount_key_private_key}",
        "client_email": "${serviceaccount_key_client_email}",
        "client_id": "${serviceaccount_key_client_id}",
        "auth_uri": "${serviceaccount_key_auth_uri}",
        "token_uri": "${serviceaccount_key_token_uri}",
        "auth_provider_x509_cert_url": "${serviceaccount_key_auth_provider_x509_cert_url}",
        "client_x509_cert_url": "${serviceaccount_key_client_x509_cert_url}",
        "universe_domain": "${serviceaccount_key_universe_domain}"
      },
      "type": "key-file"
    },
    "project_id": "${project_id}",
    "integrations": [
      %{ if artifact_registry_enabled }
      {
        "name": "registry",
        "type": "integration/docker-registry/gcp/gcr",
        "registry_url": "${artifact_registry_url}",
        "authorized_subjects": [
          "team:everyone"
        ]
      }%{ endif }
      %{ if artifact_registry_enabled && blob_storage_enabled },%{ endif }
      %{ if blob_storage_enabled }
      {
        "name": "blob",
        "type": "integration/blob-storage/gcp/gcs",
        "storage_root": "${bucket_url}",
        "authorized_subjects": [
          "team:everyone"
        ]
      }%{ endif }
      %{ if (artifact_registry_enabled || blob_storage_enabled) && secrets_manager_enabled },%{ endif }
      %{ if secrets_manager_enabled }
      {
        "name": "secrets",
        "type": "integration/secret-store/gcp/gsm",
        "authorized_subjects": [
          "team:everyone"
        ]
      }%{ endif }
      %{ if (artifact_registry_enabled || blob_storage_enabled || secrets_manager_enabled) && cluster_integration_enabled },%{ endif }
      %{ if cluster_integration_enabled }
      {
        "name": "cluster-integration",
        "type": "integration/cluster/gcp/gke-standard",
        "location": "${region}",
        "cluster_name": "${cluster_name}",
        "tfy_cluster_id": "${cluster_name}",
        "authorized_subjects": [
          "team:everyone"
        ]
      }%{ endif }
    ]
  }
}