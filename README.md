# terraform-truefoundry-integrations

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.4 |
| <a name="requirement_external"></a> [external](#requirement\_external) | 2.3.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | 2.3.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [external_external.create_cluster](https://registry.terraform.io/providers/hashicorp/external/2.3.4/docs/data-sources/external) | data source |
| [external_external.get_environment](https://registry.terraform.io/providers/hashicorp/external/2.3.4/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_always_update"></a> [always\_update](#input\_always\_update) | Forces cluster configuration updates on every terraform apply, even without changes. Use with caution as it may cause unnecessary updates. | `bool` | `false` | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | AWS Account ID where the EKS cluster will be created (e.g., '123456789012') | `string` | `null` | no |
| <a name="input_aws_cluster_integration_enabled"></a> [aws\_cluster\_integration\_enabled](#input\_aws\_cluster\_integration\_enabled) | Enable direct integration with AWS EKS cluster services | `bool` | `true` | no |
| <a name="input_aws_ecr_enabled"></a> [aws\_ecr\_enabled](#input\_aws\_ecr\_enabled) | Enable AWS Elastic Container Registry (ECR) integration for container image storage | `bool` | `true` | no |
| <a name="input_aws_parameter_store_enabled"></a> [aws\_parameter\_store\_enabled](#input\_aws\_parameter\_store\_enabled) | Enable AWS Systems Manager Parameter Store integration for secret management | `bool` | `true` | no |
| <a name="input_aws_platform_features_iam_role_enabled"></a> [aws\_platform\_features\_iam\_role\_enabled](#input\_aws\_platform\_features\_iam\_role\_enabled) | Enable AWS IAM role-based authentication. If true, requires aws\_platform\_features\_role\_arn. | `bool` | `true` | no |
| <a name="input_aws_platform_features_role_arn"></a> [aws\_platform\_features\_role\_arn](#input\_aws\_platform\_features\_role\_arn) | AWS IAM Role ARN for role-based authentication (e.g., 'arn:aws:iam::123456789012:role/TrueFoundryRole') | `string` | `null` | no |
| <a name="input_aws_platform_features_user_access_key_id"></a> [aws\_platform\_features\_user\_access\_key\_id](#input\_aws\_platform\_features\_user\_access\_key\_id) | AWS IAM Access Key ID for user-based authentication. Required if aws\_platform\_features\_user\_enabled is true. | `string` | `null` | no |
| <a name="input_aws_platform_features_user_enabled"></a> [aws\_platform\_features\_user\_enabled](#input\_aws\_platform\_features\_user\_enabled) | Enable AWS IAM user-based authentication. If true, requires aws\_platform\_features\_user\_access\_key\_id and aws\_platform\_features\_user\_secret\_access\_key. | `bool` | `false` | no |
| <a name="input_aws_platform_features_user_secret_access_key"></a> [aws\_platform\_features\_user\_secret\_access\_key](#input\_aws\_platform\_features\_user\_secret\_access\_key) | AWS IAM Secret Access Key for user-based authentication. Required if aws\_platform\_features\_user\_enabled is true. | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region where resources will be created (e.g., 'us-west-2') | `string` | `null` | no |
| <a name="input_aws_s3_bucket_name"></a> [aws\_s3\_bucket\_name](#input\_aws\_s3\_bucket\_name) | Name of the S3 bucket to use for cluster storage. Required if aws\_s3\_enabled is true. | `string` | `null` | no |
| <a name="input_aws_s3_enabled"></a> [aws\_s3\_enabled](#input\_aws\_s3\_enabled) | Enable AWS S3 integration for cluster storage capabilities | `bool` | `true` | no |
| <a name="input_aws_secrets_manager_enabled"></a> [aws\_secrets\_manager\_enabled](#input\_aws\_secrets\_manager\_enabled) | Enable AWS Secrets Manager integration for enhanced secrets management capabilities | `bool` | `false` | no |
| <a name="input_azure_acr_admin_password"></a> [azure\_acr\_admin\_password](#input\_azure\_acr\_admin\_password) | Admin password for Azure Container Registry. Required if azure\_acr\_enabled is true. | `string` | `null` | no |
| <a name="input_azure_acr_admin_username"></a> [azure\_acr\_admin\_username](#input\_azure\_acr\_admin\_username) | Admin username for Azure Container Registry. Required if azure\_acr\_enabled is true. | `string` | `null` | no |
| <a name="input_azure_acr_enabled"></a> [azure\_acr\_enabled](#input\_azure\_acr\_enabled) | Enable Azure Container Registry (ACR) integration for container image storage | `bool` | `true` | no |
| <a name="input_azure_acr_login_server"></a> [azure\_acr\_login\_server](#input\_azure\_acr\_login\_server) | Azure Container Registry login server URL (e.g., 'myregistry.azurecr.io') | `string` | `null` | no |
| <a name="input_azure_blob_storage_connection_string"></a> [azure\_blob\_storage\_connection\_string](#input\_azure\_blob\_storage\_connection\_string) | Connection string for Azure Storage Account. Required if azure\_blob\_storage\_enabled is true. | `string` | `null` | no |
| <a name="input_azure_blob_storage_enabled"></a> [azure\_blob\_storage\_enabled](#input\_azure\_blob\_storage\_enabled) | Enable Azure Blob Storage integration for cluster storage capabilities | `bool` | `true` | no |
| <a name="input_azure_blob_storage_root_url"></a> [azure\_blob\_storage\_root\_url](#input\_azure\_blob\_storage\_root\_url) | Root URL for Azure Storage Account (e.g., 'https://mystorageaccount.blob.core.windows.net') | `string` | `null` | no |
| <a name="input_azure_client_id"></a> [azure\_client\_id](#input\_azure\_client\_id) | Azure Service Principal Client ID for authentication | `string` | `null` | no |
| <a name="input_azure_client_secret"></a> [azure\_client\_secret](#input\_azure\_client\_secret) | Azure Service Principal Client Secret for authentication | `string` | `null` | no |
| <a name="input_azure_cluster_integration_enabled"></a> [azure\_cluster\_integration\_enabled](#input\_azure\_cluster\_integration\_enabled) | Enable direct integration with Azure AKS cluster services | `bool` | `true` | no |
| <a name="input_azure_resource_group_name"></a> [azure\_resource\_group\_name](#input\_azure\_resource\_group\_name) | Name of the Azure Resource Group where the AKS cluster will be created | `string` | `null` | no |
| <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id) | Azure Subscription ID where the AKS cluster will be created (e.g., '12345678-1234-1234-1234-123456789012') | `string` | `null` | no |
| <a name="input_azure_tenant_id"></a> [azure\_tenant\_id](#input\_azure\_tenant\_id) | Azure Tenant ID associated with the subscription | `string` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the Kubernetes cluster to create or manage. Must be unique within your organization. | `string` | n/a | yes |
| <a name="input_cluster_type"></a> [cluster\_type](#input\_cluster\_type) | Type of cluster to create (aws-eks, azure-aks, gcp-gke-standard) | `string` | n/a | yes |
| <a name="input_control_plane_url"></a> [control\_plane\_url](#input\_control\_plane\_url) | URL of the TrueFoundry control plane (e.g., 'https://app.truefoundry.com') | `string` | n/a | yes |
| <a name="input_gcp_artifact_registry_url"></a> [gcp\_artifact\_registry\_url](#input\_gcp\_artifact\_registry\_url) | URL for GCP Artifact Registry (e.g., 'LOCATION-docker.pkg.dev/PROJECT\_ID') | `string` | `null` | no |
| <a name="input_gcp_blob_storage_enabled"></a> [gcp\_blob\_storage\_enabled](#input\_gcp\_blob\_storage\_enabled) | Enable GCP Blob Storage integration for cluster storage capabilities | `bool` | `true` | no |
| <a name="input_gcp_cluster_integration_enabled"></a> [gcp\_cluster\_integration\_enabled](#input\_gcp\_cluster\_integration\_enabled) | Enable direct integration with GCP GKE cluster services | `bool` | `true` | no |
| <a name="input_gcp_container_registry_enabled"></a> [gcp\_container\_registry\_enabled](#input\_gcp\_container\_registry\_enabled) | Enable GCP Container Registry integration for container image storage | `bool` | `true` | no |
| <a name="input_gcp_project_id"></a> [gcp\_project\_id](#input\_gcp\_project\_id) | GCP Project ID where the GKE cluster will be created | `string` | `null` | no |
| <a name="input_gcp_region"></a> [gcp\_region](#input\_gcp\_region) | GCP Region where the GKE cluster is located | `string` | `null` | no |
| <a name="input_gcp_sa_auth_data"></a> [gcp\_sa\_auth\_data](#input\_gcp\_sa\_auth\_data) | GCP Service Account auth\_data | `string` | `null` | no |
| <a name="input_gcp_secrets_manager_enabled"></a> [gcp\_secrets\_manager\_enabled](#input\_gcp\_secrets\_manager\_enabled) | Enable GCP Secrets Manager integration for secret management | `bool` | `true` | no |
| <a name="input_gcp_service_account_enabled"></a> [gcp\_service\_account\_enabled](#input\_gcp\_service\_account\_enabled) | Enable GCP Service Account integration for authentication | `bool` | `true` | no |
| <a name="input_gcp_service_account_key_enabled"></a> [gcp\_service\_account\_key\_enabled](#input\_gcp\_service\_account\_key\_enabled) | Enable GCP Service Account key for authentication | `bool` | `true` | no |
| <a name="input_gcp_storage_bucket_url"></a> [gcp\_storage\_bucket\_url](#input\_gcp\_storage\_bucket\_url) | URL for GCP Storage bucket (e.g., 'gs://bucket-name') | `string` | `null` | no |
| <a name="input_stderr_log_file"></a> [stderr\_log\_file](#input\_stderr\_log\_file) | Log file of stdout | `string` | `"truefoundry-cluster.stderr"` | no |
| <a name="input_stdout_log_file"></a> [stdout\_log\_file](#input\_stdout\_log\_file) | Log file of stdout | `string` | `"truefoundry-cluster.stdout"` | no |
| <a name="input_tenant_name"></a> [tenant\_name](#input\_tenant\_name) | Name of the tenant | `string` | `null` | no |
| <a name="input_tfy_api_key"></a> [tfy\_api\_key](#input\_tfy\_api\_key) | TrueFoundry API key for authentication. Can be obtained from the TrueFoundry console. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The ID of the created cluster |
| <a name="output_cluster_token"></a> [cluster\_token](#output\_cluster\_token) | The token for the cluster |
| <a name="output_provider_integration_enabled"></a> [provider\_integration\_enabled](#output\_provider\_integration\_enabled) | Whether the provider integration is enabled |
| <a name="output_tenant_name"></a> [tenant\_name](#output\_tenant\_name) | The name of the tenant |
<!-- END_TF_DOCS -->
