{
  "manifest": {
    "name": "${cluster_name}",
    "type": "provider-account/aws",
    "auth_data": {
    %{ if platform_user_enabled }
    "type": "access-key-based",
    "access_key_id": "${platform_user_access_key}",
    "secret_access_key": "${platform_user_secret_key}"
    %{ else }
    "type": "assumed-role-based",
    "assumed_role_arn": "${platform_iam_role_arn}"
    %{ endif }
  },
  "aws_account_id": "${account_id}",
  "integrations": [
    %{ if s3_enabled }
    {
      "name": "blob",
      "type": "integration/blob-storage/aws/s3",
      "region": "${region}",
      "authorized_subjects": ["team:everyone"],
      "storage_root": "s3://${platform_user_bucket_name}"
    }%{ endif }
    %{ if s3_enabled && ecr_enabled },%{ endif }
    %{ if ecr_enabled }
    {
      "name": "registry",
      "type": "integration/docker-registry/aws/ecr",
      "authorized_subjects": ["team:everyone"],
      "registry_url": "${account_id}.dkr.ecr.${region}.amazonaws.com"
    }%{ endif }
    %{ if (s3_enabled || ecr_enabled) && parameter_store_enabled },%{ endif }
    %{ if parameter_store_enabled }
    {
      "name": "parameter-store",
      "type": "integration/secret-store/aws/parameter-store",
      "authorized_subjects": ["team:everyone"],
      "region": "${region}"
      }%{ endif }
    ]
  }
}
