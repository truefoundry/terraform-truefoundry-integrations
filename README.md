# terraform-truefoundry-integrations
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
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
| <a name="input_artifact_registry_url"></a> [artifact\_registry\_url](#input\_artifact\_registry\_url) | URL for GCP Artifact Registry | `string` | `null` | no |
| <a name="input_blob_storage_connection_string"></a> [blob\_storage\_connection\_string](#input\_blob\_storage\_connection\_string) | Connection string for Azure Blob Storage | `string` | `null` | no |
| <a name="input_blob_storage_enabled"></a> [blob\_storage\_enabled](#input\_blob\_storage\_enabled) | Flag to enable/disable Azure Blob Storage integration | `bool` | `false` | no |
| <a name="input_blob_storage_root_url"></a> [blob\_storage\_root\_url](#input\_blob\_storage\_root\_url) | Root URL for Azure Blob Storage | `string` | `null` | no |
| <a name="input_bucket_url"></a> [bucket\_url](#input\_bucket\_url) | URL for GCP Storage bucket | `string` | `null` | no |
| <a name="input_cloud_account_id"></a> [cloud\_account\_id](#input\_cloud\_account\_id) | Cloud provider account ID/Project ID/Subscription ID | `string` | `null` | no |
| <a name="input_cloud_region"></a> [cloud\_region](#input\_cloud\_region) | Cloud provider region name | `string` | `null` | no |
| <a name="input_cluster_integration_client_id"></a> [cluster\_integration\_client\_id](#input\_cluster\_integration\_client\_id) | Client ID for Azure cluster integration | `string` | `null` | no |
| <a name="input_cluster_integration_client_secret"></a> [cluster\_integration\_client\_secret](#input\_cluster\_integration\_client\_secret) | Client secret for Azure cluster integration | `string` | `null` | no |
| <a name="input_cluster_integration_enabled"></a> [cluster\_integration\_enabled](#input\_cluster\_integration\_enabled) | Flag to enable/disable cluster integration | `bool` | `false` | no |
| <a name="input_cluster_integration_tenant_id"></a> [cluster\_integration\_tenant\_id](#input\_cluster\_integration\_tenant\_id) | Tenant ID for Azure cluster integration | `string` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster to create | `string` | n/a | yes |
| <a name="input_cluster_type"></a> [cluster\_type](#input\_cluster\_type) | Type of cluster to create (aws-eks, azure-aks, or gcp-gke-standard) | `string` | n/a | yes |
| <a name="input_container_registry_admin_password"></a> [container\_registry\_admin\_password](#input\_container\_registry\_admin\_password) | Admin password for Azure Container Registry | `string` | `null` | no |
| <a name="input_container_registry_admin_username"></a> [container\_registry\_admin\_username](#input\_container\_registry\_admin\_username) | Admin username for Azure Container Registry | `string` | `null` | no |
| <a name="input_container_registry_enabled"></a> [container\_registry\_enabled](#input\_container\_registry\_enabled) | Flag to enable/disable container registry integration (ECR/GCR/ACR) | `bool` | `false` | no |
| <a name="input_container_registry_login_server"></a> [container\_registry\_login\_server](#input\_container\_registry\_login\_server) | Login server URL for Azure Container Registry | `string` | `null` | no |
| <a name="input_control_plane_url"></a> [control\_plane\_url](#input\_control\_plane\_url) | URL of the control plane | `string` | n/a | yes |
| <a name="input_object_store_bucket_name"></a> [object\_store\_bucket\_name](#input\_object\_store\_bucket\_name) | Name of the object storage bucket | `string` | `null` | no |
| <a name="input_object_store_enabled"></a> [object\_store\_enabled](#input\_object\_store\_enabled) | Flag to enable/disable object storage integration (S3/GCS/Blob Storage) | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | `null` | no |
| <a name="input_secret_store_enabled"></a> [secret\_store\_enabled](#input\_secret\_store\_enabled) | Flag to enable/disable secret store integration | `bool` | `false` | no |
| <a name="input_service_account_enabled"></a> [service\_account\_enabled](#input\_service\_account\_enabled) | Flag to enable/disable service account/platform user | `bool` | `false` | no |
| <a name="input_service_account_key_id"></a> [service\_account\_key\_id](#input\_service\_account\_key\_id) | Cloud provider service account key ID/access key/client ID | `string` | `null` | no |
| <a name="input_service_account_key_secret"></a> [service\_account\_key\_secret](#input\_service\_account\_key\_secret) | Cloud provider service account key secret/access secret/client secret | `string` | `null` | no |
| <a name="input_service_account_role_arn"></a> [service\_account\_role\_arn](#input\_service\_account\_role\_arn) | Cloud provider service account role ARN/role ID/role name | `string` | `null` | no |
| <a name="input_serviceaccount_key_auth_provider_x509_cert_url"></a> [serviceaccount\_key\_auth\_provider\_x509\_cert\_url](#input\_serviceaccount\_key\_auth\_provider\_x509\_cert\_url) | Auth provider x509 cert URL for GCP service account | `string` | `"https://www.googleapis.com/oauth2/v1/certs"` | no |
| <a name="input_serviceaccount_key_auth_uri"></a> [serviceaccount\_key\_auth\_uri](#input\_serviceaccount\_key\_auth\_uri) | Auth URI for GCP service account | `string` | `"https://accounts.google.com/o/oauth2/auth"` | no |
| <a name="input_serviceaccount_key_client_email"></a> [serviceaccount\_key\_client\_email](#input\_serviceaccount\_key\_client\_email) | Client email for GCP service account | `string` | `null` | no |
| <a name="input_serviceaccount_key_client_id"></a> [serviceaccount\_key\_client\_id](#input\_serviceaccount\_key\_client\_id) | Client ID for GCP service account | `string` | `null` | no |
| <a name="input_serviceaccount_key_client_x509_cert_url"></a> [serviceaccount\_key\_client\_x509\_cert\_url](#input\_serviceaccount\_key\_client\_x509\_cert\_url) | Client x509 cert URL for GCP service account | `string` | `null` | no |
| <a name="input_serviceaccount_key_private_key"></a> [serviceaccount\_key\_private\_key](#input\_serviceaccount\_key\_private\_key) | Private key for GCP service account | `string` | `null` | no |
| <a name="input_serviceaccount_key_project_id"></a> [serviceaccount\_key\_project\_id](#input\_serviceaccount\_key\_project\_id) | Project ID for GCP service account | `string` | `null` | no |
| <a name="input_serviceaccount_key_token_uri"></a> [serviceaccount\_key\_token\_uri](#input\_serviceaccount\_key\_token\_uri) | Token URI for GCP service account | `string` | `"https://oauth2.googleapis.com/token"` | no |
| <a name="input_serviceaccount_key_type"></a> [serviceaccount\_key\_type](#input\_serviceaccount\_key\_type) | Type of GCP service account key | `string` | `null` | no |
| <a name="input_serviceaccount_key_universe_domain"></a> [serviceaccount\_key\_universe\_domain](#input\_serviceaccount\_key\_universe\_domain) | Universe domain for GCP service account | `string` | `"googleapis.com"` | no |
| <a name="input_tfy_api_key"></a> [tfy\_api\_key](#input\_tfy\_api\_key) | API key for authentication | `string` | n/a | yes |
| <a name="input_trigger_helm_update"></a> [trigger\_helm\_update](#input\_trigger\_helm\_update) | Trigger Helm update | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The ID of the created cluster |
| <a name="output_cluster_token"></a> [cluster\_token](#output\_cluster\_token) | The token for the cluster |
| <a name="output_tenant_name"></a> [tenant\_name](#output\_tenant\_name) | The name of the tenant |
<!-- END_TF_DOCS -->