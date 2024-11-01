name: ${cluster_name}
type: provider-account/azure
subscription_id: ${subscription_id}
authorized_subjects:
  - team:everyone
integrations:
%{ if platform_features.container_registry != null }
  - name: registry
    type: integration/docker-registry/azure/acr
    auth_data:
      type: basic-auth
      password: ${platform_features.container_registry.admin_password}
      username: ${platform_features.container_registry.admin_username}
    registry_url: ${platform_features.container_registry.login_server}
%{ endif }
%{ if platform_features.blob_storage != null }
  - name: blob
    type: integration/blob-storage/azure/blob
    auth_data:
      type: connection-string
      connection_string: ${platform_features.blob_storage.connection_string}
    storage_root: ${platform_features.blob_storage.root_url}
%{ endif } 