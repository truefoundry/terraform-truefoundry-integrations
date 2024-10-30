name: ${cluster_name}
type: provider-account/gcp
auth_data:
  key_file_content:
    type: ${platform_features.serviceaccount_key.type}
    project_id: ${platform_features.serviceaccount_key.project_id}
    private_key_id: ${platform_features.serviceaccount_key.private_key_id}
    private_key: "${platform_features.serviceaccount_key.private_key}"
    client_email: ${platform_features.serviceaccount_key.client_email}
    client_id: "${platform_features.serviceaccount_key.client_id}"
    auth_uri: ${platform_features.serviceaccount_key.auth_uri}
    token_uri: ${platform_features.serviceaccount_key.token_uri}
    auth_provider_x509_cert_url: ${platform_features.serviceaccount_key.auth_provider_x509_cert_url}
    client_x509_cert_url: ${platform_features.serviceaccount_key.client_x509_cert_url}
    universe_domain: ${platform_features.serviceaccount_key.universe_domain}
  type: key-file
project_id: ${project_id}
integrations:
%{ if platform_features.artifact_registry_url != null }
  - name: registry
    type: integration/docker-registry/gcp/gcr
    registry_url: ${platform_features.artifact_registry_url}
    authorized_subjects:
      - team:everyone
%{ endif }
%{ if platform_features.bucket_url != null }
  - name: blob
    type: integration/blob-storage/gcp/gcs
    storage_root: ${platform_features.bucket_url}
    authorized_subjects:
      - team:everyone
%{ endif } 