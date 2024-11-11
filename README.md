# terraform-truefoundry-integrations
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.4 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.5 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | ~> 2.5 |
| <a name="provider_null"></a> [null](#provider\_null) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.create_cluster](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [local_file.cluster_output](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_access_key_id"></a> [aws\_access\_key\_id](#input\_aws\_access\_key\_id) | AWS IAM Access Key ID | `string` | `null` | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | AWS Account ID | `string` | `null` | no |
| <a name="input_aws_cluster_integration_enabled"></a> [aws\_cluster\_integration\_enabled](#input\_aws\_cluster\_integration\_enabled) | Flag to enable/disable AWS EKS cluster integration | `bool` | `false` | no |
| <a name="input_aws_ecr_enabled"></a> [aws\_ecr\_enabled](#input\_aws\_ecr\_enabled) | Flag to enable/disable AWS ECR integration | `bool` | `false` | no |
| <a name="input_aws_parameter_store_enabled"></a> [aws\_parameter\_store\_enabled](#input\_aws\_parameter\_store\_enabled) | Flag to enable/disable AWS Parameter Store integration | `bool` | `false` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region name | `string` | `null` | no |
| <a name="input_aws_role_arn"></a> [aws\_role\_arn](#input\_aws\_role\_arn) | AWS IAM Role ARN | `string` | `null` | no |
| <a name="input_aws_s3_bucket_name"></a> [aws\_s3\_bucket\_name](#input\_aws\_s3\_bucket\_name) | AWS S3 bucket name | `string` | `null` | no |
| <a name="input_aws_s3_enabled"></a> [aws\_s3\_enabled](#input\_aws\_s3\_enabled) | Flag to enable/disable AWS S3 integration | `bool` | `false` | no |
| <a name="input_aws_secret_access_key"></a> [aws\_secret\_access\_key](#input\_aws\_secret\_access\_key) | AWS IAM Secret Access Key | `string` | `null` | no |
| <a name="input_aws_secrets_manager_enabled"></a> [aws\_secrets\_manager\_enabled](#input\_aws\_secrets\_manager\_enabled) | Flag to enable AWS Secrets Manager integration | `bool` | `false` | no |
| <a name="input_aws_service_account_enabled"></a> [aws\_service\_account\_enabled](#input\_aws\_service\_account\_enabled) | Flag to enable/disable AWS IAM service account | `bool` | `false` | no |
| <a name="input_azure_acr_admin_password"></a> [azure\_acr\_admin\_password](#input\_azure\_acr\_admin\_password) | Azure Container Registry admin password | `string` | `null` | no |
| <a name="input_azure_acr_admin_username"></a> [azure\_acr\_admin\_username](#input\_azure\_acr\_admin\_username) | Azure Container Registry admin username | `string` | `null` | no |
| <a name="input_azure_acr_enabled"></a> [azure\_acr\_enabled](#input\_azure\_acr\_enabled) | Flag to enable/disable Azure Container Registry integration | `bool` | `false` | no |
| <a name="input_azure_acr_login_server"></a> [azure\_acr\_login\_server](#input\_azure\_acr\_login\_server) | Azure Container Registry login server URL | `string` | `null` | no |
| <a name="input_azure_client_id"></a> [azure\_client\_id](#input\_azure\_client\_id) | Azure Service Principal Client ID | `string` | `null` | no |
| <a name="input_azure_client_secret"></a> [azure\_client\_secret](#input\_azure\_client\_secret) | Azure Service Principal Client Secret | `string` | `null` | no |
| <a name="input_azure_cluster_integration_enabled"></a> [azure\_cluster\_integration\_enabled](#input\_azure\_cluster\_integration\_enabled) | Flag to enable/disable Azure AKS cluster integration | `bool` | `false` | no |
| <a name="input_azure_resource_group_name"></a> [azure\_resource\_group\_name](#input\_azure\_resource\_group\_name) | Azure Resource Group name | `string` | `null` | no |
| <a name="input_azure_storage_connection_string"></a> [azure\_storage\_connection\_string](#input\_azure\_storage\_connection\_string) | Azure Storage Account connection string | `string` | `null` | no |
| <a name="input_azure_storage_enabled"></a> [azure\_storage\_enabled](#input\_azure\_storage\_enabled) | Flag to enable/disable Azure Blob Storage integration | `bool` | `false` | no |
| <a name="input_azure_storage_root_url"></a> [azure\_storage\_root\_url](#input\_azure\_storage\_root\_url) | Azure Storage Account root URL | `string` | `null` | no |
| <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id) | Azure Subscription ID | `string` | `null` | no |
| <a name="input_azure_tenant_id"></a> [azure\_tenant\_id](#input\_azure\_tenant\_id) | Azure Tenant ID | `string` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster to create | `string` | n/a | yes |
| <a name="input_cluster_type"></a> [cluster\_type](#input\_cluster\_type) | Type of cluster to create (aws-eks, azure-aks, or gcp-gke-standard) | `string` | n/a | yes |
| <a name="input_control_plane_url"></a> [control\_plane\_url](#input\_control\_plane\_url) | URL of the control plane | `string` | n/a | yes |
| <a name="input_gcp_artifact_registry_url"></a> [gcp\_artifact\_registry\_url](#input\_gcp\_artifact\_registry\_url) | GCP Artifact Registry URL | `string` | `null` | no |
| <a name="input_gcp_project_id"></a> [gcp\_project\_id](#input\_gcp\_project\_id) | GCP Project ID | `string` | `null` | no |
| <a name="input_gcp_sa_auth_provider_cert_url"></a> [gcp\_sa\_auth\_provider\_cert\_url](#input\_gcp\_sa\_auth\_provider\_cert\_url) | GCP Service Account auth provider cert URL | `string` | `"https://www.googleapis.com/oauth2/v1/certs"` | no |
| <a name="input_gcp_sa_auth_uri"></a> [gcp\_sa\_auth\_uri](#input\_gcp\_sa\_auth\_uri) | GCP Service Account auth URI | `string` | `"https://accounts.google.com/o/oauth2/auth"` | no |
| <a name="input_gcp_sa_client_cert_url"></a> [gcp\_sa\_client\_cert\_url](#input\_gcp\_sa\_client\_cert\_url) | GCP Service Account client cert URL | `string` | `null` | no |
| <a name="input_gcp_sa_client_email"></a> [gcp\_sa\_client\_email](#input\_gcp\_sa\_client\_email) | GCP Service Account client email | `string` | `null` | no |
| <a name="input_gcp_sa_client_id"></a> [gcp\_sa\_client\_id](#input\_gcp\_sa\_client\_id) | GCP Service Account client ID | `string` | `null` | no |
| <a name="input_gcp_sa_key_type"></a> [gcp\_sa\_key\_type](#input\_gcp\_sa\_key\_type) | GCP Service Account key type | `string` | `null` | no |
| <a name="input_gcp_sa_private_key"></a> [gcp\_sa\_private\_key](#input\_gcp\_sa\_private\_key) | GCP Service Account private key | `string` | `null` | no |
| <a name="input_gcp_sa_project_id"></a> [gcp\_sa\_project\_id](#input\_gcp\_sa\_project\_id) | GCP Service Account project ID | `string` | `null` | no |
| <a name="input_gcp_sa_token_uri"></a> [gcp\_sa\_token\_uri](#input\_gcp\_sa\_token\_uri) | GCP Service Account token URI | `string` | `"https://oauth2.googleapis.com/token"` | no |
| <a name="input_gcp_sa_universe_domain"></a> [gcp\_sa\_universe\_domain](#input\_gcp\_sa\_universe\_domain) | GCP Service Account universe domain | `string` | `"googleapis.com"` | no |
| <a name="input_gcp_storage_bucket_url"></a> [gcp\_storage\_bucket\_url](#input\_gcp\_storage\_bucket\_url) | GCP Storage bucket URL | `string` | `null` | no |
| <a name="input_tfy_api_key"></a> [tfy\_api\_key](#input\_tfy\_api\_key) | API key for authentication | `string` | n/a | yes |
| <a name="input_trigger_helm_update"></a> [trigger\_helm\_update](#input\_trigger\_helm\_update) | Trigger Helm update | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The ID of the created cluster |
| <a name="output_cluster_token"></a> [cluster\_token](#output\_cluster\_token) | The token for the cluster |
| <a name="output_tenant_name"></a> [tenant\_name](#output\_tenant\_name) | The name of the tenant |
<!-- END_TF_DOCS -->