{
  "manifest": {
    "name": "${cluster_name}",
    "type": "provider-account/aws",
    "auth_data": {
    %{ if platform_features_user_enabled }
      "type": "access-key-based",
      "access_key_id": "${platform_features_user_key_id}",
      "secret_access_key": "${platform_features_user_key_secret}"
    %{ else }
      "type": "assumed-role-based",
      "assumed_role_arn": "${platform_features_role_arn}"
    %{ endif }
    },
    "aws_account_id": "${cloud_account_id}",
    "integrations": [
      %{ if object_store_enabled }
      {
        "name": "blob",
        "type": "integration/blob-storage/aws/s3",
        "region": "${cloud_region}",
        "authorized_subjects": ["team:everyone"],
        "storage_root": "s3://${object_store_bucket_name}"
      }%{ endif }
      %{ if object_store_enabled && container_registry_enabled },%{ endif }
      %{ if container_registry_enabled }
      {
        "name": "registry",
        "type": "integration/docker-registry/aws/ecr",
        "authorized_subjects": ["team:everyone"],
        "registry_url": "${cloud_account_id}.dkr.ecr.${cloud_region}.amazonaws.com"
      }%{ endif }
      %{ if (object_store_enabled || container_registry_enabled) && parameter_store_enabled },%{ endif }
      %{ if parameter_store_enabled }
      {
        "name": "parameter-store",
        "type": "integration/secret-store/aws/parameter-store",
        "authorized_subjects": ["team:everyone"],
        "region": "${cloud_region}"
      }%{ endif }
      %{ if (object_store_enabled || container_registry_enabled || parameter_store_enabled) && secrets_manager_enabled },%{ endif }
      %{ if secrets_manager_enabled }
      {
        "name": "secrets-manager",
        "type": "integration/secret-store/aws/secrets-manager",
        "authorized_subjects": ["team:everyone"],
        "region": "${cloud_region}"
      }%{ endif }
      %{ if (object_store_enabled || container_registry_enabled || parameter_store_enabled || secrets_manager_enabled) && cluster_integration_enabled },%{ endif }
      %{ if cluster_integration_enabled }
      {
        "name": "cluster-integration",
        "type": "integration/cluster/aws/eks",
        "region": "${cloud_region}",
        "authorized_subjects": ["team:everyone"],
        "cluster_name": "${cluster_name}"
      }%{ endif }
    ]
  }
}
